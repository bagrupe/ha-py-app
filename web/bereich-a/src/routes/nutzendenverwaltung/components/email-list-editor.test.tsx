/** @vitest-environment jsdom */
import {fireEvent, render, within} from '@testing-library/react';
import {describe, expect, it, vi} from 'vitest';
import {EmailListEditor} from './email-list-editor.tsx';

describe('EmailListEditor', () => {
  it('rejects an address without a top-level domain (e.g. "d@d")', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={[]} onChange={onChange} />,
    );
    const {getByLabelText, getByText, getByRole} = within(container);

    const input = getByLabelText('E-Mail-Adresse');
    fireEvent.change(input, {target: {value: 'd@d'}});
    fireEvent.click(getByRole('button', {name: 'E-Mail-Adresse hinzufügen'}));

    expect(onChange).not.toHaveBeenCalled();
    expect(
      getByText('Bitte geben Sie eine gültige E-Mail-Adresse ein.'),
    ).toBeTruthy();
  });

  it('shows a message when clicking add without having typed anything', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={[]} onChange={onChange} />,
    );
    const {getByText, getByRole} = within(container);

    fireEvent.click(getByRole('button', {name: 'E-Mail-Adresse hinzufügen'}));

    expect(onChange).not.toHaveBeenCalled();
    expect(
      getByText('Bitte geben Sie zuerst eine E-Mail-Adresse ein.'),
    ).toBeTruthy();
  });

  it('does not show an error when leaving an empty field without clicking add', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={[]} onChange={onChange} />,
    );
    const {getByLabelText, queryByText} = within(container);

    fireEvent.blur(getByLabelText('E-Mail-Adresse'));

    expect(
      queryByText('Bitte geben Sie zuerst eine E-Mail-Adresse ein.'),
    ).toBeNull();
  });

  it('shows a message when adding an address that is already present (case-insensitive)', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={['valid@example.de']} onChange={onChange} />,
    );
    const {getByLabelText, getByText, getByRole} = within(container);

    const input = getByLabelText('E-Mail-Adresse');
    fireEvent.change(input, {target: {value: 'VALID@example.de'}});
    fireEvent.click(getByRole('button', {name: 'E-Mail-Adresse hinzufügen'}));

    expect(onChange).not.toHaveBeenCalled();
    expect(
      getByText('Diese E-Mail-Adresse ist bereits vorhanden.'),
    ).toBeTruthy();
  });

  it('accepts an address with a valid top-level domain', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={[]} onChange={onChange} />,
    );
    const {getByLabelText, getByRole} = within(container);

    const input = getByLabelText('E-Mail-Adresse');
    fireEvent.change(input, {target: {value: 'valid@example.de'}});
    fireEvent.click(getByRole('button', {name: 'E-Mail-Adresse hinzufügen'}));

    expect(onChange).toHaveBeenCalledWith(['valid@example.de']);
  });

  it('prevents the add button from stealing focus on mousedown, so clicking it does not blur (and prematurely clear) the draft input first', () => {
    const onChange = vi.fn();
    const {container} = render(
      <EmailListEditor value={[]} onChange={onChange} />,
    );
    const {getByRole} = within(container);

    const addButton = getByRole('button', {
      name: 'E-Mail-Adresse hinzufügen',
    });
    const event = new MouseEvent('mousedown', {
      bubbles: true,
      cancelable: true,
    });
    const preventDefaultSpy = vi.spyOn(event, 'preventDefault');
    addButton.dispatchEvent(event);

    expect(preventDefaultSpy).toHaveBeenCalled();
  });
});
