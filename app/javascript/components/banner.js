import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  const banner = document.getElementById("banner-typed-text");
  if (banner) {
    new Typed('#banner-typed-text', {
      strings: ["Join DocPat today", "be in control of your family’s health history", "anytime, anyplace, anywhere"],
      typeSpeed: 75,
      loop: true
    });
  }
}

export { loadDynamicBannerText };
