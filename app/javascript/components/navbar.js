

const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-wagon');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= navbar.clientHeight) {
        navbar.classList.add('navbar-wagon-white');
      } else {
        navbar.classList.remove('navbar-wagon-white');
      }
    });
  }
}

const highlightActiveLink = () => {
  // const links = document.querySelectorAll('.navbar-wagon-link');
  // links.forEach((link) => {
  //   link.addEventListener('click', (event) => {
  //     links.forEach((link) => {
  //       link.classList.remove('navbar-wagon-link-active');
  //     });
  //     event.currentTarget.classList.add('navbar-wagon-link-active');
  //   });
  // });
}

export { initUpdateNavbarOnScroll };
export { highlightActiveLink };
