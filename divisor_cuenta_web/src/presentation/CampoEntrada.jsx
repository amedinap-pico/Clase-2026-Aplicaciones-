export function CampoEntrada({
  id,
  label,
  name,
  value,
  onChange,
  inputMode,
  placeholder,
  error,
}) {
  const errorId = `${id}-error`

  return (
    <div className="form-field">
      <label htmlFor={id}>{label}</label>
      <input
        id={id}
        name={name}
        type="text"
        inputMode={inputMode}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
        autoComplete="off"
        aria-invalid={Boolean(error)}
        aria-describedby={error ? errorId : undefined}
      />
      {error && (
        <span className="field-error" id={errorId}>
          {error}
        </span>
      )}
    </div>
  )
}
