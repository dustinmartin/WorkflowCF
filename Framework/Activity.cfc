<cfcomponent output="false">

<!------------------------------------------ CONSTRUCTOR ------------------------------------------->

	<cfset variables.instance = structNew() />
	<cfset variables.instance.errorHandler = "" />

	<cffunction name="init" access="public" returntype="component">
		<cfreturn this />
	</cffunction>

<!------------------------------------------- PUBLIC ----------------------------------------------->

	<cffunction name="execute" access="public" returntype="void">
   		<cfargument name="context" type="component" required="true" />
		<cfthrow
			type="Workflow.Framework.Activity.MethodNotImplemented"
			message="Execute method not implemented." />
	</cffunction>

	<cffunction name="getActivityName" access="public" output="false" returntype="string">
		<cfreturn getMetaData(this).name />
    </cffunction>

	<cffunction name="getErrorHandler" access="public" output="false" returntype="component">
    	<cfreturn variables.instance.errorHandler />
    </cffunction>

	<cffunction name="hasErrorHandler" access="public" output="false" returntype="boolean">
    	<cfif isObject(variables.instance.errorHandler)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
    </cffunction>

	<cffunction name="setErrorHandler" access="public" output="false" returntype="void">
    	<cfargument name="errorHandler" type="any" required="true" />
    	<cfset variables.instance.errorHandler = arguments.errorHandler />
    </cffunction>

<!------------------------------------------- PRIVATE ---------------------------------------------->

</cfcomponent>