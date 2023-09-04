// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import PortfolioListToggleController from "./portfolio_list_toggle_controller"
application.register("portfolio-list-toggle", PortfolioListToggleController)
