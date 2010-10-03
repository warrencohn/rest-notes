package net.terminalapp.notes.app;

import net.terminalapp.notes.model.entities.Note;
import net.terminalapp.notes.model.entities.User;
import net.terminalapp.notes.rest.controllers.NoteController;
import net.terminalapp.notes.rest.controllers.UserController;
import er.extensions.appserver.ERXApplication;
import er.rest.routes.ERXRouteRequestHandler;

public class Application extends ERXApplication {
	public static void main(String[] argv) {
		ERXApplication.main(argv, Application.class);
	}

	public Application() {
		ERXApplication.log.info("Welcome to " + name() + " !");
		
		ERXRouteRequestHandler routeRequestHandler = new ERXRouteRequestHandler( ERXRouteRequestHandler.RAILS );
		routeRequestHandler.addDefaultRoutes( Note.ENTITY_NAME, NoteController.class );
		routeRequestHandler.addDefaultRoutes( User.ENTITY_NAME, UserController.class );
		ERXRouteRequestHandler.register(routeRequestHandler);
	}
}
