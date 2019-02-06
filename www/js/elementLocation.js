//  Used by methods in "UIWebView+ElementLocation.h" category.

const stringEndsWith = (str, suffix) => str.indexOf(suffix, str.length - suffix.length) !== -1

exports.getImageWithSrc = src => document.querySelector(`img[src$="${src}"]`)

exports.getElementRect = element => {
  const rect = element.getBoundingClientRect()
  // Important: use "X", "Y", "Width" and "Height" keys so we can use CGRectMakeWithDictionaryRepresentation in native land to convert to CGRect.
  return {
    Y: rect.top,
    X: rect.left,
    Width: rect.width,
    Height: rect.height
  }
}

exports.getIndexOfFirstOnScreenElement = (elementPrefix, elementCount) => {
  for (let i = 0; i < elementCount; ++i) {
    const div = document.getElementById(elementPrefix + i)
    if (div === null) {
      continue
    }
    const rect = this.getElementRect(div)
    if (rect.Y >= -1 || rect.Y + rect.Height >= 50) {
      return i
    }
  }
  return -1
}

exports.getElementFromPoint = (x, y) => document.elementFromPoint(x - window.pageXOffset, y - window.pageYOffset)

exports.isElementTopOnscreen = element => element.getBoundingClientRect().top < 0


const isElementOnscreen = (element) => {
  var rect = element.getBoundingClientRect()
  var windowHeight = window.innerHeight
  var bottom = rect.top + rect.height
  return rect.top > 0 && rect.top < windowHeight || bottom > 0 && bottom < windowHeight || rect.top < 0 && bottom > windowHeight
}

exports.getOnScreenElementIndices = (elementPrefix, elementCount) => {
  var indexFromElement = element => parseInt(element.id.substring(elementPrefix.length), 10)
  return Array.from(document.querySelectorAll(`[id^=${elementPrefix}]`))
    .filter(isElementOnscreen)
    .map(indexFromElement)
}