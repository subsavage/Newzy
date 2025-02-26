require("dotenv").config();
const express = require("express");
const axios = require("axios");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

const PORT = 5000;
const NEWS_API_KEY = process.env.NEWS_API_KEY;
const MONGO_URI = process.env.MONGO_URI;

// Connect to MongoDB
mongoose
  .connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.error(err));

// Define the FavoriteArticle schema
const favoriteArticleSchema = new mongoose.Schema({
  title: String,
  url: String,
  source: String,
  category: String,
});

const FavoriteArticle = mongoose.model("FavoriteArticle", favoriteArticleSchema);

// Fetch news articles based on category
app.get("/news", async (req, res) => {
  try {
    const { category } = req.query;
    const url = `https://newsapi.org/v2/top-headlines?country=us&category=${category || "general"}&apiKey=${NEWS_API_KEY}`;

    const response = await axios.get(url);
    res.json(response.data.articles);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch news" });
  }
});

// Store favorite articles
app.post("/favorites", async (req, res) => {
  try {
    const { title, url, source, category } = req.body;
    const article = new FavoriteArticle({ title, url, source, category });

    await article.save();
    res.json({ message: "Article saved successfully", article });
  } catch (error) {
    res.status(500).json({ error: "Failed to save article" });
  }
});

// Get all favorite articles
app.get("/favorites", async (req, res) => {
  try {
    const articles = await FavoriteArticle.find();
    res.json(articles);
  } catch (error) {
    res.status(500).json({ error: "Failed to retrieve favorites" });
  }
});

// Delete a favorite article
app.delete("/favorites/:id", async (req, res) => {
  try {
    await FavoriteArticle.findByIdAndDelete(req.params.id);
    res.json({ message: "Article removed from favorites" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete article" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
