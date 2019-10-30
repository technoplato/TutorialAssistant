import React from 'react'
import { useField } from 'formik'

export default ({ label, handleChange, ...props }) => {
  const [field, meta] = useField({ name: props.name })
  return (
    <div className="row">
      <div className="row">
        <label>{label}</label>
      </div>
      <div className="row">
        <input onChange={handleChange} {...field} {...props} />
      </div>
      {meta.touched && meta.error ? (
        <div className="error">{meta.error}</div>
      ) : null}
    </div>
  )
}
