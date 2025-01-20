import pluginJs from "@eslint/js";

export default [
  {
    languageOptions: {
      globals: {
        window: "readonly",
        document: "readonly",
      },
    },
    ignores: ["config/tailwind.config.js", "spec/dummy/vendor/"],
    ...pluginJs.configs.recommended,
  }
];

