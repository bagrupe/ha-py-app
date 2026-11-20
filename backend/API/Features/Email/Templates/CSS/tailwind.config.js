const originalConfig = require("../../../../../../web/bereich-a/tailwind.config");

/** @type {import('tailwindcss').Config} */
module.exports = {
    ...originalConfig,
    content: ["../**/*.razor"],
}