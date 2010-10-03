package net.terminalapp.notes.model.migration;

import net.terminalapp.notes.model.entities.User;

import com.webobjects.eoaccess.EOAdaptorChannel;
import com.webobjects.eoaccess.EOModel;
import com.webobjects.eoaccess.EOUtilities;
import com.webobjects.eocontrol.EOEditingContext;
import com.webobjects.foundation.NSArray;

import er.extensions.migration.ERXModelVersion;
import er.extensions.migration.IERXPostMigration;

public class NotesModel1 implements IERXPostMigration {
	@Override
	public NSArray<ERXModelVersion> modelDependencies() {
		return null;
	}

	@Override
	public void postUpgrade( EOEditingContext editingContext, EOModel model ) throws Throwable {
		User user = (User) EOUtilities.createAndInsertInstance( editingContext, User.ENTITY_NAME );
		user.setUsername( "user" );
		user.setPassword( "pass" );
		editingContext.saveChanges();
	}

	@Override
	public void downgrade( EOEditingContext editingContext, EOAdaptorChannel channel, EOModel model ) throws Throwable {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void upgrade( EOEditingContext editingContext, EOAdaptorChannel channel, EOModel model ) throws Throwable {
		// TODO Auto-generated method stub
		
	}
  
	
	
	
	
	
}