import Vue from "vue";
import VueRouter from "vue-router";
import Libro from "../views/Book.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Book",
    component: Libro,
  },
  {
    path: "/user",
    name: "User",
    component: () => import("../views/User.vue"),
  },
  {
    path: "/loan",
    name: "Loan",
    component: () => import("../views/Loan.vue"),
  },
  {
    path: "/about",
    name: "About",
    component: () => import("../views/About.vue"),
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
