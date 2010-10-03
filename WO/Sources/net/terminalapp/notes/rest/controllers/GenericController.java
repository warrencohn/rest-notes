package net.terminalapp.notes.rest.controllers;

import java.io.IOException;

import net.terminalapp.notes.app.components.ErrorResponse;
import net.terminalapp.notes.model.entities.User;

import sun.misc.BASE64Decoder;

import com.webobjects.appserver.WOActionResults;
import com.webobjects.appserver.WORequest;
import com.webobjects.appserver.WOResponse;

import er.rest.routes.ERXDefaultRouteController;

public abstract class GenericController extends ERXDefaultRouteController {
	
	private String authUsername;
	private String authPassword;
	private User authenticatedUser;

	public GenericController( WORequest request ) {
		super( request );
		
		initAuthentication();
	}
	
	protected void initAuthentication() {
		String authValue = request().headerForKey( "authorization" );
		
		if( authValue != null ) {
			try {
				byte[] authBytes = new BASE64Decoder().decodeBuffer( authValue.replace( "Basic ", "" ) );
				String[] parts = new String( authBytes ).split( ":", 2 );
				setAuthUsername( parts[0] );
				setAuthPassword( parts[1] );
				setAuthenticatedUser( User.userForUsernameWithPassword( authUsername(), authPassword(), editingContext() ) );
			} catch ( IOException e ) {
				log.error( "Could not decode basic auth data: " + e.getMessage() );
				e.printStackTrace();
			}
		}
	}
	
	protected WOActionResults errorPageForStatusAndMessage( int status, String message ) {
		ErrorResponse error = pageWithName( ErrorResponse.class );
		WOResponse response = error.generateResponse();
		if( message != null ) {
			response.appendHeader( message, "X-Restnotes-Error" );
		}
		response.setStatus( status );
		return response;
	}

	protected void setAuthUsername( String authUsername ) {
		this.authUsername = authUsername;
	}

	public String authUsername() {
		return authUsername;
	}

	protected void setAuthPassword( String authPassword ) {
		this.authPassword = authPassword;
	}

	public String authPassword() {
		return authPassword;
	}

	public void setAuthenticatedUser( User authenticatedUser ) {
		this.authenticatedUser = authenticatedUser;
	}

	public User authenticatedUser() {
		return authenticatedUser;
	}
}
