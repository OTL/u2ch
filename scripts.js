function checkFontAndAddLoading(font, baseText, loadingText, indicator) {
if (font.status == FontLoader.Ready) {
    if (indicator) {
        indicator.running = false;
    }
  return baseText;
} else {
    if (indicator) {
        indicator.running = true;
    }

    return loadingText;
}
}
