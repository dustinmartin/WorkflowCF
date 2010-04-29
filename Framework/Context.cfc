<cfcomponent output="false">

<!------------------------------------------ CONSTRUCTOR ------------------------------------------->

	<cfset variables.instance = structNew() />
	<cfset variables.instance.messages = arrayNew(1) />
	<cfset variables.instance.seedData = structNew() />
	<cfset variables.instance.workflowData = structNew() />
	<cfset variables.instance.stopProcess = false />

	<cffunction name="init" access="public" returntype="component">
		<cfargument name="params" type="struct" required="false" default="#structNew()#" />

		<cfset setSeedData( arguments.params ) />

		<cfreturn this />
	</cffunction>

<!------------------------------------------- PUBLIC ----------------------------------------------->

	<cffunction name="addMessage" access="public" output="false" returntype="void">
		<cfargument name="activityName" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="info">

		<cfset arrayAppend(variables.instance.messages,arguments) />
	</cffunction>

	<cffunction name="getMessages" access="public" output="false" returntype="array">
   		<cfreturn variables.instance.messages />
	</cffunction>

	<cffunction name="getSeedData" access="public" output="false" returntype="struct">
    	<cfreturn variables.instance.seedData />
    </cffunction>

	<cffunction name="stopProcess" access="public" output="false" returntype="void">
		<cfset variables.instance.stopProcess = true />
	</cffunction>

	<cffunction name="processShouldStop" access="public" output="false" returntype="boolean">
    	<cfreturn variables.instance.stopProcess />
    </cffunction>

	<cffunction name="getWorkflowData" access="public" output="false" returntype="struct">
    	<cfreturn variables.instance.workflowData />
    </cffunction>

	<cffunction name="setWorkflowData" access="public" output="false" returntype="void">
    	<cfargument name="workflowData" type="struct" required="true" />
    	<cfset variables.instance.workflowData = arguments.workflowData />
    </cffunction>

<!------------------------------------------- PRIVATE ---------------------------------------------->

	<cffunction name="setSeedData" access="private" output="false" returntype="void">
    	<cfargument name="seedData" type="struct" required="true" />
    	<cfset variables.instance.seedData = arguments.seedData />
    </cffunction>

</cfcomponent>