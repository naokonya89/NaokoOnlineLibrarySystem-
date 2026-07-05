const express = require("express");
const { getBooks, getBookById, createBook, updateBook, deleteBook } = require("../controllers/bookController");
const { protect, authorizeRoles } = require("../middleware/authMiddleware");
const router = express.Router();

router.route("/").get(getBooks).post(protect, authorizeRoles("admin"), createBook);
router.route("/:id").get(getBookById).put(protect, authorizeRoles("admin"), updateBook).delete(protect, authorizeRoles("admin"), deleteBook);

module.exports = router;
