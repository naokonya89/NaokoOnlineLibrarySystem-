const supabase = require("../config/supabase");
const crypto = require("crypto");

const apiProtect = async (req, res, next) => {
  let apiKey = req.headers["x-api-key"];

  if (!apiKey) {
    return res.status(401).json({ message: "API Key missing" });
  }

  try {
    // Hash the incoming API key to compare with stored hashed keys
    const hashedApiKey = crypto.createHash("sha256").update(apiKey).digest("hex");

    const { data, error } = await supabase
      .from("api_keys")
      .select("*, developer:profiles(id, full_name)")
      .eq("key_hash", hashedApiKey)
      .eq("status", "active")
      .single();

    if (error || !data) {
      return res.status(401).json({ message: "Invalid or inactive API Key" });
    }

    req.apiKey = data;
    // TODO: Implement rate limiting logic here
    // TODO: Log API usage here
    next();
  } catch (error) {
    console.error("API Key authentication error:", error);
    res.status(500).json({ message: "Internal server error during API key validation" });
  }
};

module.exports = { apiProtect };
