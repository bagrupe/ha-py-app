type VariableMapping<TName extends string> = { [key in TName]: string };

export const blazorVariables = <TName extends string>(
  names: TName[],
  previewValues?: Partial<VariableMapping<TName>>,
) => {
  const variables = Object.fromEntries(
    names.map((name) => {
      const preview = previewValues?.[name];
      return [
        name,
        process.env.NODE_ENV === "production" || !preview
          ? `@${name}`
          : preview,
      ];
    })
  ) as VariableMapping<TName>;

  return variables;
};
