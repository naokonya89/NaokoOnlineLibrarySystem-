const supabase = require("../config/supabase");
const { z } = require("zod");

// Zod schema for book validation
const bookSchema = z.object({
  title: z.string().min(1, "Title is required"),
  author: z.string().min(1, "Author is required"),
  isbn: z.string().optional(),
  category_id: z.string().uuid("Invalid category ID").optional(),
  description: z.string().optional(),
  cover_image_url: z.string().url("Invalid URL").optional(),
  total_copies: z.number().int().min(0, "Total copies cannot be negative").optional().default(0),
  available_copies: z.number().int().min(0, "Available copies cannot be negative").optional().default(0),
});

// @desc    Get all books
// @route   GET /api/books
// @access  Public
const getBooks = async (req, res) => {
  const { data, error } = await supabase.from("books").select("*");

  if (error) {
    return res.status(500).json({ message: error.message });
  }
  res.status(200).json(data);
};

// @desc    Get single book by ID
// @route   GET /api/books/:id
// @access  Public
const getBookById = async (req, res) => {
  const { id } = req.params;
  const { data, error } = await supabase.from("books").select("*").eq("id", id).single();

  if (error) {
    if (error.code === "PGRST116") {
      return res.status(404).json({ message: "Book not found" });
    }
    return res.status(500).json({ message: error.message });
  }
  res.status(200).json(data);
};

// @desc    Create a new book
// @route   POST /api/books
// @access  Admin
const createBook = async (req, res) => {
  try {
    const validatedData = bookSchema.parse(req.body);
    const { data, error } = await supabase.from("books").insert([validatedData]).select();

    if (error) {
      return res.status(500).json({ message: error.message });
    }
    res.status(201).json(data[0]);
  } catch (error) {
    res.status(400).json({ message: error.errors });
  }
};

// @desc    Update a book
// @route   PUT /api/books/:id
// @access  Admin
const updateBook = async (req, res) => {
  const { id } = req.params;
  try {
    const validatedData = bookSchema.partial().parse(req.body); // Use partial for updates
    const { data, error } = await supabase.from("books").update(validatedData).eq("id", id).select();

    if (error) {
      return res.status(500).json({ message: error.message });
    }
    if (!data || data.length === 0) {
      return res.status(404).json({ message: "Book not found" });
    }
    res.status(200).json(data[0]);
  } catch (error) {
    res.status(400).json({ message: error.errors });
  }
};

// @desc    Delete a book
// @route   DELETE /api/books/:id
// @access  Admin
const deleteBook = async (req, res) => {
  const { id } = req.params;
  const { error } = await supabase.from("books").delete().eq("id", id);

  if (error) {
    return res.status(500).json({ message: error.message });
  }
  res.status(204).send(); // No content for successful deletion
};

module.exports = {
  getBooks,
  getBookById,
  createBook,
  updateBook,
  deleteBook,
};
