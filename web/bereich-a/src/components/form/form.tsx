import {type PropsWithChildren} from 'react';
import {
  type FieldValues,
  FormProvider,
  type SubmitHandler,
  type UseFormProps,
  type UseFormReturn,
} from 'react-hook-form';

/**
 * Eigenschaften für die `Form`-Komponente, die mit `react-hook-form` arbeitet.
 *
 * @template T - Der Typ der Felder in diesem Formular.
 *
 * @param builder - Instanz von `UseFormReturn`, die von `react-hook-form` zurückgegeben wird und die gesamte Formularlogik verwaltet.
 * @param className - CSS-Klasse für das `form`-Element.
 * @param onSubmit - Callback, der bei der Einreichung des Formulars ausgeführt wird.
 * @param children - Kinderkomponenten, die innerhalb des Formulars gerendert werden.
 */
export type FormProps<T extends FieldValues> = UseFormProps<T> & {
  builder: UseFormReturn<T>;
  className?: string;
  onSubmit?: SubmitHandler<T>;
};

/**
 * Formular-Komponente, die `react-hook-form`-Integration bietet und automatisch den `FormProvider` umschließt.
 *
 * @template T - Der Typ der in diesem Formular genutzten Felder.
 *
 * @param props - Eigenschaften wie der Formular-Builder (`UseFormReturn`), CSS-Klassen und ein Submit-Handler.
 *
 * Diese Komponente vereinfacht die Verwendung von `react-hook-form`, indem sie die Hierarchie für den `FormProvider` und die `handleSubmit`-Logik kapselt.
 */
export function Form<T extends FieldValues>(
  props: PropsWithChildren<FormProps<T>>,
) {
  const {builder, onSubmit, ...formProps} = props;
  return (
    <FormProvider {...builder}>
      <form
        onSubmit={onSubmit ? builder.handleSubmit(onSubmit) : undefined}
        {...formProps}
      />
    </FormProvider>
  );
}
