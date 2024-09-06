import pluginJs from "@eslint/js";


export default [
  {
    languageOptions: {
      globals: {
        window: "readonly",
        document: "readonly",
      },
    },
    ...pluginJs.configs.recommended,
  }
];
