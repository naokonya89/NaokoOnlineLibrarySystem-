-- Seed data for categories
INSERT INTO categories (id, name, description) VALUES
    (gen_random_uuid(), 'Fiction', 'Fictional stories and novels'),
    (gen_random_uuid(), 'Science', 'Books on various scientific disciplines'),
    (gen_random_uuid(), 'History', 'Historical accounts and analyses'),
    (gen_random_uuid(), 'Biography', 'Life stories of notable individuals'),
    (gen_random_uuid(), 'Fantasy', 'Fantasy novels and series');

-- Seed data for books (example, replace with more diverse data)
INSERT INTO books (id, title, author, isbn, category_id, description, cover_image_url, total_copies, available_copies) VALUES
    (gen_random_uuid(), 'The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565', (SELECT id FROM categories WHERE name = 'Fiction'), 'A classic novel of the Jazz Age.', 'https://example.com/gatsby.jpg', 5, 3),
    (gen_random_uuid(), 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', '978-0062316097', (SELECT id FROM categories WHERE name = 'History'), 'A brief history of humankind.', 'https://example.com/sapiens.jpg', 7, 5),
    (gen_random_uuid(), 'Cosmos', 'Carl Sagan', '978-0345539434', (SELECT id FROM categories WHERE name = 'Science'), 'A journey through space and time.', 'https://example.com/cosmos.jpg', 4, 2),
    (gen_random_uuid(), 'Becoming', 'Michelle Obama', '978-1524763138', (SELECT id FROM categories WHERE name = 'Biography'), 'A memoir by former First Lady Michelle Obama.', 'https://example.com/becoming.jpg', 6, 4),
    (gen_random_uuid(), 'The Hobbit', 'J.R.R. Tolkien', '978-0345339683', (SELECT id FROM categories WHERE name = 'Fantasy'), 'A fantasy novel by J.R.R. Tolkien.', 'https://example.com/hobbit.jpg', 8, 6),
    (gen_random_uuid(), '1984', 'George Orwell', '978-0451524935', (SELECT id FROM categories WHERE name = 'Fiction'), 'A dystopian social science fiction novel.', 'https://example.com/1984.jpg', 5, 3),
    (gen_random_uuid(), 'A Brief History of Time', 'Stephen Hawking', '978-0553380163', (SELECT id FROM categories WHERE name = 'Science'), 'A popular-science book on cosmology.', 'https://example.com/hawking.jpg', 6, 4),
    (gen_random_uuid(), 'The Diary of a Young Girl', 'Anne Frank', '978-0553296983', (SELECT id FROM categories WHERE name = 'Biography'), 'The wartime diary of Anne Frank.', 'https://example.com/annefrank.jpg', 4, 2),
    (gen_random_uuid(), 'The Lord of the Rings', 'J.R.R. Tolkien', '978-0618053267', (SELECT id FROM categories WHERE name = 'Fantasy'), 'An epic high-fantasy adventure novel.', 'https://example.com/lotr.jpg', 9, 7),
    (gen_random_uuid(), 'To Kill a Mockingbird', 'Harper Lee', '978-0061120084', (SELECT id FROM categories WHERE name = 'Fiction'), 'A novel about the serious issues of rape and racial inequality.', 'https://example.com/mockingbird.jpg', 7, 5),
    (gen_random_uuid(), 'The Selfish Gene', 'Richard Dawkins', '978-0198788607', (SELECT id FROM categories WHERE name = 'Science'), 'A book on evolution by Richard Dawkins.', 'https://example.com/selfishgene.jpg', 5, 3),
    (gen_random_uuid(), 'Guns, Germs, and Steel', 'Jared Diamond', '978-0393317558', (SELECT id FROM categories WHERE name = 'History'), 'A book on the factors that led to the rise of civilizations.', 'https://example.com/guns.jpg', 6, 4),
    (gen_random_uuid(), 'Steve Jobs', 'Walter Isaacson', '978-1451648539', (SELECT id FROM categories WHERE name = 'Biography'), 'The authorized biography of Steve Jobs.', 'https://example.com/jobs.jpg', 5, 3),
    (gen_random_uuid(), 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', '978-0590353427', (SELECT id FROM categories WHERE name = 'Fantasy'), 'The first novel in the Harry Potter series.', 'https://example.com/harrypotter.jpg', 10, 8),
    (gen_random_uuid(), 'Pride and Prejudice', 'Jane Austen', '978-0141439518', (SELECT id FROM categories WHERE name = 'Fiction'), 'A romantic novel of manners.', 'https://example.com/pride.jpg', 6, 4);

-- Seed data for sample members (example, replace with actual user IDs if available)
-- Note: These UUIDs should correspond to actual user IDs in auth.users table for RLS to work correctly.
-- For demonstration, we'll use placeholder UUIDs. In a real scenario, these would be created via Supabase Auth.
INSERT INTO profiles (id, full_name, role) VALUES
    (gen_random_uuid(), 'John Doe', 'member'),
    (gen_random_uuid(), 'Jane Smith', 'member'),
    (gen_random_uuid(), 'Admin User', 'admin'),
    (gen_random_uuid(), 'Developer User', 'developer');
