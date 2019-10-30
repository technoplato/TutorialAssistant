export default (orig, find, replace) => {
  return orig.split(find).join(replace)
}
