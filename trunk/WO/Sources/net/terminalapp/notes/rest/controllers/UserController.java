package net.terminalapp.notes.rest.controllers;

import net.terminalapp.notes.app.components.ErrorResponse;
import net.terminalapp.notes.model.entities.User;

import com.webobjects.appserver.WOActionResults;
import com.webobjects.appserver.WORequest;
import com.webobjects.appserver.WOResponse;
import com.webobjects.eoaccess.EOGeneralAdaptorException;
import com.webobjects.foundation.NSLog;

import er.extensions.eof.ERXKey;
import er.extensions.eof.ERXKeyFilter;
import er.rest.routes.jsr311.GET;
import er.rest.routes.jsr311.Path;

public class UserController extends GenericController {

	public UserController( WORequest request ) {
		super( request );
		// TODO Auto-generated constructor stub
	}

	@Override
	protected String entityName() {
		return User.ENTITY_NAME;
	}
	
	protected User user() {
		User user = routeObjectForKey("user");
		return user;
	}
	
	public ERXKeyFilter publicInfoFilter() {
		return ERXKeyFilter.filterWithKeys( new ERXKey<User>( User.USERNAME_KEY ) );
	}
	
	@Override
	public WOActionResults createAction() throws Throwable {
		try {
			NSLog.out.appendln("createAction");
			User user = create(ERXKeyFilter.filterWithAttributes());
			editingContext().saveChanges();
			return response(user, publicInfoFilter());
		} catch ( EOGeneralAdaptorException e ) {
			if( e.getMessage().toLowerCase().contains( "unique_n_user__username" ) ) {
				ErrorResponse error = pageWithName( ErrorResponse.class );
				WOResponse response = error.generateResponse();
				response.appendHeader( "That username is already taken. Please choose another username.", "X-Restnotes-Error" );
				response.setStatus( WOResponse.HTTP_STATUS_INTERNAL_ERROR );
				return response;
			}
			
			throw e;
		}
	}

	@Override
	public WOActionResults destroyAction() throws Throwable {
		return null;
	}

	@Override
	public WOActionResults indexAction() throws Throwable {
		return null;
	}

	@Override
	public WOActionResults newAction() throws Throwable {
		NSLog.out.appendln("newAction");
		
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public WOActionResults showAction() throws Throwable {
		return response( user(), publicInfoFilter() );
	}

	@Override
	public WOActionResults updateAction() throws Throwable {
		return null;
	}
	
	@GET
	@Path("/user/login")
	public WOActionResults loginAction() throws Throwable {
		if( authenticatedUser() == null ) {
			throw new SecurityException();
		}
		return response( authenticatedUser(), publicInfoFilter() );
	}
	
	
}
