--- 
# Generic Build Process Scripts
--- 		
Generic build scripts for Joomla! website extensions.<br/>
<br/>
* Documentation and download extension: http://www.pvln.nl/build-joomla <br/>
<br/>
Below folder structure should be present on the workstation on which development is done:

``` 
extensionname\code           folder with all code related items
             \code\src       folder with the code for the Joomla! extension, 
                             which gets installed on the Joomla! website
             \code\doc       documentation related to the source code
             \code\set       specific settings for the extension
             \code\tst       tests for the source code
			 
extensionname\bld            folder with scripts to build the extension zipfile (<- THIS CODE)
			 
extensionname\stg            folder with scripts to stage it to the update and download webserver

extensionname\dpl            folder with generic deploy scripts for Joomla! website extensions

extensionname\struc          scripts to create the Joomla! deployment skeleton (this skeleton) 

             \misc           folder with relevant information links and inspiration
			 \misc\original  if relevant the original code which is changed in \code\src
             \_set           folder with settings used by various scripts
             \_bin           folder with the output files from scripts.
                             files in this folder are shared between different scripts.
             \_tmp           folder used to place temporary output files from scripts.
                             folder is shared between different scripts.
``` 
