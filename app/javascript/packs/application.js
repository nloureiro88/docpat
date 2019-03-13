import "bootstrap";

import { initUpdateNavbarOnScroll } from '../components/navbar';
initUpdateNavbarOnScroll();

import { loadDynamicBannerText } from '../components/banner';
loadDynamicBannerText();

import { datePicker } from '../components/datepicker';
datePicker();

import { initSweetalert } from '../components/init_sweetalert';

initSweetalert('#sweet-alert-demo', {
  title: "A nice alert",
  text: "This is a great alert, isn't it?",
  icon: "success"
});

// import { initSweetalert } from '../components/init_sweetalert';

// initSweetalert('#sweet-alert-demo', {
//   title: "A nice alert",
//   text: "This is a great alert, isn't it?",
//   icon: "success"
// }, (value) => {
//   console.log(value);
// });



// const pagesHome = document.queryselector(".pages.home");
// if (pagesHome) {
//   // ......
// }

