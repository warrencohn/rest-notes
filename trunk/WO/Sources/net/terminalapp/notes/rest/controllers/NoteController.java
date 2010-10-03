package net.terminalapp.notes.rest.controllers;

import net.terminalapp.notes.model.entities.Note;

import com.webobjects.appserver.WOActionResults;
import com.webobjects.appserver.WOMessage;
import com.webobjects.appserver.WORequest;
import com.webobjects.eocontrol.EOSortOrdering;
import com.webobjects.foundation.NSArray;
import com.webobjects.foundation.NSLog;

import er.extensions.eof.ERXKey;
import er.extensions.eof.ERXKeyFilter;
import er.extensions.eof.ERXQ;
import er.rest.ERXRestFetchSpecification;
import er.rest.routes.jsr311.GET;
import er.rest.routes.jsr311.Path;

public class NoteController extends GenericController {

	public NoteController( WORequest request ) {
		super( request );
		// TODO Auto-generated constructor stub
	}

	@Override
	protected String entityName() {
		return Note.ENTITY_NAME;
	}
	
	protected Note note() {
		Note note = routeObjectForKey("note");
		return note;
	}
	
	public ERXKeyFilter indexFilter() {
		return ERXKeyFilter.filterWithKeys( new ERXKey<Note>( Note.CREATION_DATE_KEY ), new ERXKey<Note>( Note.CONTENT_PREVIEW_KEY ) );
	}
	
	@Override
	protected void checkAccess() throws SecurityException {
		if( authenticatedUser() == null ) {
			throw new SecurityException();
		}
		super.checkAccess();
	}
	
	@Override
	public WOActionResults createAction() throws Throwable {
		Note note = create(ERXKeyFilter.filterWithAttributes());
		note.setUserRelationship( authenticatedUser() );
		editingContext().saveChanges();
		return response(note, ERXKeyFilter.filterWithAll());
	}

	@Override
	public WOActionResults destroyAction() throws Throwable {
		if( note().user() != authenticatedUser() ) {
			return errorPageForStatusAndMessage( WOMessage.HTTP_STATUS_FORBIDDEN, null );
		}
		editingContext().deleteObject( note() );
		editingContext().saveChanges();
		return response(note(), ERXKeyFilter.filterWithAll());
	}

	@Override
	public WOActionResults indexAction() throws Throwable {
		EOSortOrdering dateOrdering = new EOSortOrdering( Note.CREATION_DATE_KEY, EOSortOrdering.CompareDescending );
		ERXRestFetchSpecification<Note> fetchSpec = new ERXRestFetchSpecification<Note>(Note.ENTITY_NAME, ERXQ.equals( Note.USER_KEY, authenticatedUser() ), null, ERXKeyFilter.filterWithAll(), new NSArray<EOSortOrdering>( new EOSortOrdering[] { dateOrdering } ), 25);
		return response( fetchSpec, indexFilter() );
	}

	@Override
	public WOActionResults newAction() throws Throwable {
		NSLog.out.appendln("newAction");
		
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public WOActionResults showAction() throws Throwable {
		if( note().user() != authenticatedUser() ) {
			return errorPageForStatusAndMessage( WOMessage.HTTP_STATUS_FORBIDDEN, null );
		}
		return response( note(), ERXKeyFilter.filterWithAll() );
	}

	@Override
	public WOActionResults updateAction() throws Throwable {
		Note note = note();
		if( note.user() != authenticatedUser() ) {
			return errorPageForStatusAndMessage( WOMessage.HTTP_STATUS_FORBIDDEN, null );
		}
		update( note, ERXKeyFilter.filterWithAttributes() );
		editingContext().saveChanges();
		return response( note, ERXKeyFilter.filterWithAll() );
	}
	
	@GET
	@Path("/note/random")
	public WOActionResults randomAction() throws Throwable {
		Note note = Note.randomNote( editingContext() );
		note.setUserRelationship( authenticatedUser() );
		editingContext().saveChanges();
		return response( note, ERXKeyFilter.filterWithAll() );
	}
	
	/* @Override
	public WOActionResults performActionNamed( String actionName ) {
		if( authenticatedUser() == null ) {
			return errorPageForStatusAndMessage( WOMessage.HTTP_STATUS_FORBIDDEN, null );
		}
		return super.performActionNamed( actionName );
	} */

}
