const jwt = require("jsonwebtoken");
const supabase = require("../config/supabase");

const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
    try {
      token = req.headers.authorization.split(" ")[1];

      // Verify token
      const { data, error } = await supabase.auth.getUser(token);

      if (error) {
        return res.status(401).json({ message: "Not authorized, token failed" });
      }

      // Attach the user to the request
      req.user = data.user;
      next();
    } catch (error) {
      console.error(error);
      res.status(401).json({ message: "Not authorized, token failed" });
    }
  }

  if (!token) {
    res.status(401).json({ message: "Not authorized, no token" });
  }
};

const authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!req.user || !req.user.user_metadata || !req.user.user_metadata.role) {
      return res.status(403).json({ message: "Forbidden: User role not found" });
    }
    if (!roles.includes(req.user.user_metadata.role)) {
      return res.status(403).json({ message: `Forbidden: User with role ${req.user.user_metadata.role} is not allowed to access this resource` });
    }
    next();
  };
};

module.exports = { protect, authorizeRoles };
