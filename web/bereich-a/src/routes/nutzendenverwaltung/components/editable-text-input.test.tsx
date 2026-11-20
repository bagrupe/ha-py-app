/** @vitest-environment jsdom */
import {cleanup, fireEvent, render, waitFor} from '@testing-library/react';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {EditableTextForm} from './editable-text-input.tsx';

afterEach(cleanup);

describe('EditableTextForm', () => {
  it('stays editable when saving fails', async () => {
    const onUpdate = vi.fn().mockResolvedValue(false);
    const {container} = render(
      <EditableTextForm<{name: string; id?: string}>
        object={{name: 'Bürgeramt'}}
        onUpdate={onUpdate}
        onDelete={vi.fn()}
      />,
    );
    const input = container.querySelector('input')!;
    const editOrSave = container.querySelector('button')!;

    fireEvent.click(editOrSave);
    expect(input.disabled).toBe(false);
    fireEvent.click(editOrSave);

    await waitFor(() => expect(onUpdate).toHaveBeenCalledOnce());
    expect(input.disabled).toBe(false);
  });

  it('becomes read-only after a successful save', async () => {
    const onUpdate = vi.fn().mockResolvedValue(true);
    const {container} = render(
      <EditableTextForm<{name: string; id?: string}>
        object={{name: 'Bürgeramt'}}
        onUpdate={onUpdate}
        onDelete={vi.fn()}
      />,
    );
    const input = container.querySelector('input')!;
    const editOrSave = container.querySelector('button')!;

    fireEvent.click(editOrSave);
    fireEvent.click(editOrSave);

    await waitFor(() => expect(input.disabled).toBe(true));
  });

  it('shows a summary of eMailAdressen and lets entries be added while editing', async () => {
    const onUpdate = vi.fn().mockResolvedValue(true);
    const {container, getByText, getByLabelText, getByRole, queryByLabelText} =
      render(
        <EditableTextForm<{
          name: string;
          id?: string;
          eMailAdressen: string[];
        }>
          object={{name: 'Bürgeramt', eMailAdressen: ['erste@example.com']}}
          onUpdate={onUpdate}
          onDelete={vi.fn()}
        />,
      );

    expect(getByText('erste@example.com')).toBeTruthy();

    const editOrSave = container.querySelector('button')!;
    fireEvent.click(editOrSave);

    const draftInput = getByLabelText('E-Mail-Adresse') as HTMLInputElement;
    fireEvent.change(draftInput, {target: {value: 'zweite@example.com'}});
    fireEvent.click(getByRole('button', {name: 'E-Mail-Adresse hinzufügen'}));
    fireEvent.click(editOrSave);

    await waitFor(() =>
      expect(onUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          eMailAdressen: ['erste@example.com', 'zweite@example.com'],
        }),
      ),
    );
    await waitFor(() => expect(queryByLabelText('E-Mail-Adresse')).toBeNull());
  });

  it('keeps a typed but unconfirmed eMailAdressen draft when saving directly', async () => {
    const onUpdate = vi.fn().mockResolvedValue(true);
    const {container, getByLabelText, queryByLabelText} = render(
      <EditableTextForm<{
        name: string;
        id?: string;
        eMailAdressen: string[];
      }>
        object={{name: 'Bürgeramt', eMailAdressen: ['erste@example.com']}}
        onUpdate={onUpdate}
        onDelete={vi.fn()}
      />,
    );

    const editOrSave = container.querySelector('button')!;
    fireEvent.click(editOrSave);

    const draftInput = getByLabelText('E-Mail-Adresse') as HTMLInputElement;
    fireEvent.change(draftInput, {target: {value: 'zweite@example.com'}});
    fireEvent.blur(draftInput);
    fireEvent.click(editOrSave);

    await waitFor(() =>
      expect(onUpdate).toHaveBeenCalledWith(
        expect.objectContaining({
          eMailAdressen: ['erste@example.com', 'zweite@example.com'],
        }),
      ),
    );
    await waitFor(() => expect(queryByLabelText('E-Mail-Adresse')).toBeNull());
  });
});
