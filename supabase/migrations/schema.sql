-- Create profiles table
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    role TEXT DEFAULT 'member' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for profiles table
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy for public access (no direct public access, only authenticated)
-- Policy for members to view/update their own profile
CREATE POLICY "Members can view and update their own profile" ON profiles
  FOR SELECT TO authenticated USING (auth.uid() = id);
CREATE POLICY "Members can update their own profile" ON profiles
  FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Policy for admins to have full access
CREATE POLICY "Admins can manage all profiles" ON profiles
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create categories table
CREATE TABLE categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for categories table
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Policy for public/authenticated to read categories
CREATE POLICY "Public can read categories" ON categories
  FOR SELECT USING (TRUE);
-- Policy for admins to manage categories
CREATE POLICY "Admins can manage categories" ON categories
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create books table
CREATE TABLE books (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    isbn TEXT UNIQUE,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    description TEXT,
    cover_image_url TEXT,
    total_copies INT DEFAULT 0 NOT NULL,
    available_copies INT DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for books table
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- Policy for public/authenticated to read books
CREATE POLICY "Public can read books" ON books
  FOR SELECT USING (TRUE);
-- Policy for admins to manage books
CREATE POLICY "Admins can manage books" ON books
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create borrowings table
CREATE TABLE borrowings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    borrowed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    returned_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'borrowed' NOT NULL, -- 'borrowed', 'returned', 'overdue'
    fine_amount NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    CONSTRAINT chk_status CHECK (status IN ('borrowed', 'returned', 'overdue'))
);

-- Enable RLS for borrowings table
ALTER TABLE borrowings ENABLE ROW LEVEL SECURITY;

-- Policy for members to view/manage their own borrowings
CREATE POLICY "Members can view their own borrowings" ON borrowings
  FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Members can create their own borrowings" ON borrowings
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Members can update their own borrowings" ON borrowings
  FOR UPDATE TO authenticated USING (auth.uid() = user_id);
-- Policy for admins to manage all borrowings
CREATE POLICY "Admins can manage all borrowings" ON borrowings
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create reservations table
CREATE TABLE reservations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    status TEXT DEFAULT 'pending' NOT NULL, -- 'pending', 'fulfilled', 'cancelled'
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_reservation_status CHECK (status IN ('pending', 'fulfilled', 'cancelled'))
);

-- Enable RLS for reservations table
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;

-- Policy for members to view/manage their own reservations
CREATE POLICY "Members can view their own reservations" ON reservations
  FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Members can create their own reservations" ON reservations
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Members can update their own reservations" ON reservations
  FOR UPDATE TO authenticated USING (auth.uid() = user_id);
-- Policy for admins to manage all reservations
CREATE POLICY "Admins can manage all reservations" ON reservations
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create reviews table
CREATE TABLE reviews (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (user_id, book_id) -- One review per user per book
);

-- Enable RLS for reviews table
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Policy for public/authenticated to read reviews
CREATE POLICY "Public can read reviews" ON reviews
  FOR SELECT USING (TRUE);
-- Policy for members to view/manage their own reviews
CREATE POLICY "Members can manage their own reviews" ON reviews
  FOR ALL TO authenticated USING (auth.uid() = user_id);
-- Policy for admins to manage all reviews
CREATE POLICY "Admins can manage all reviews" ON reviews
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create api_keys table
CREATE TABLE api_keys (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    developer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    key_hash TEXT NOT NULL UNIQUE,
    label TEXT,
    status TEXT DEFAULT 'active' NOT NULL, -- 'active', 'revoked'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_used_at TIMESTAMP WITH TIME ZONE,
    rate_limit INT DEFAULT 1000 NOT NULL -- requests per hour
);

-- Enable RLS for api_keys table
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;

-- Policy for developers to view/manage their own API keys
CREATE POLICY "Developers can manage their own API keys" ON api_keys
  FOR ALL TO authenticated USING (auth.uid() = developer_id AND EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'developer'));
-- Policy for admins to manage all API keys
CREATE POLICY "Admins can manage all API keys" ON api_keys
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create api_usage_logs table
CREATE TABLE api_usage_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    api_key_id UUID REFERENCES api_keys(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    status_code INT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for api_usage_logs table
ALTER TABLE api_usage_logs ENABLE ROW LEVEL SECURITY;

-- Policy for developers to view their own API usage logs
CREATE POLICY "Developers can view their own API usage logs" ON api_usage_logs
  FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM api_keys WHERE id = api_key_id AND developer_id = auth.uid()));
-- Policy for admins to view all API usage logs
CREATE POLICY "Admins can view all API usage logs" ON api_usage_logs
  FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Create announcements table
CREATE TABLE announcements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for announcements table
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;

-- Policy for public/authenticated to read announcements
CREATE POLICY "Public can read announcements" ON announcements
  FOR SELECT USING (TRUE);
-- Policy for admins to manage announcements
CREATE POLICY "Admins can manage announcements" ON announcements
  FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Function to set user role after sign up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (NEW.id, NEW.raw_user_meta_data->>
'full_name', 'member');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call handle_new_user function on auth.users insert
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Set up admin role manually for initial admin user
-- INSERT INTO public.profiles (id, full_name, role) VALUES ('<ADMIN_USER_UUID>', 'Admin User', 'admin');
