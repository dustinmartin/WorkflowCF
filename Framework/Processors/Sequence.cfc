<cfcomponent output="false">

<!------------------------------------------ CONSTRUCTOR ------------------------------------------->

	<cfset variables.instance = structNew() />
	<cfset variables.instance.workflowName = "" />
	<cfset variables.instance.activities = "" />
	<cfset variables.instance.processContextClass = "" />
	<cfset variables.instance.defaultErrorHandler = "" />
	<cfset variables.instance.logger = "" />

	<cffunction name="init" access="public" returntype="component">
		<cfargument name="WorkflowName" type="string" required="true" />
		<cfargument name="Activities" type="array" required="true" />
		<cfargument name="ProcessContextClass" type="string" required="false" default=""/>
		<cfargument name="DefaultErrorHandler" type="any" required="false" default="" />
		<cfargument name="Logger" type="any" required="false" default="" />

		<cfset setWorkflowName( arguments.workflowName ) />
		<cfset setActivities( arguments.activities ) />
		<cfset setProcessContextClass( arguments.processContextClass ) />
		<cfset setDefaultErrorHandler( arguments.defaultErrorHandler ) />
		<cfset setLogger( arguments.logger ) />

		<cfreturn this />
	</cffunction>

<!------------------------------------------- PUBLIC ----------------------------------------------->

	<cffunction name="process" access="public" output="false" returntype="component">
		<cfargument name="params" type="struct" required="false" default="#structNew()#" />

		<cfset var activities = getActivities() />
		<cfset var activity = 0 />
		<cfset var context = createContext(params) />

		<cfif hasLogger()><cfset getLogger().debug("Beginning Workflow: #getWorkflowName()#") /></cfif>

		<cfloop from="1" to="#arrayLen(activities)#" index="i">
			<cfset activity = activities[i] />

			<cfif hasLogger()><cfset getLogger().debug("Executing activity: #activity.getActivityName()#") /></cfif>

			<cftry>
				<cfset activity.execute(context) />

				<cfcatch type="any">
					<cfif hasLogger()><cfset getLogger().error("Exception in workflow: #getWorkflowName()# - Activity: #activity.getActivityName()#") /></cfif>

					<cfset result.isSuccess(false) />

					<cfif activity.hasErrorHandler()>
						<cfif hasLogger()><cfset getLogger().info("Handling error with custom error handler for activity #activity.getActivityName()#") /></cfif>
						<cfset activity.getErrorHandler().handleError(cfcatch) />
					<cfelseif hasDefaultErrorHandler()>
						<cfif hasLogger()><cfset getLogger().info("Handling error with default error handler for workflow #getWorkflowName()#") /></cfif>
						<cfset getDefaultErrorHandler().handleError(cfcatch) />
					<cfelse>
						<cfif hasLogger()><cfset getLogger().info("No error handler defined. Rethrowing exception.") /></cfif>
						<cfrethrow />
					</cfif>
				</cfcatch>
			</cftry>

			<cfif hasLogger()><cfset getLogger().debug("Finished executing activity: #activity.getActivityName()#") /></cfif>

			<cfif context.processShouldStop()>
				<cfif hasLogger()><cfset getLogger().debug("Workflow process interrupted by activity: #activity.getActivityName()#") /></cfif>
				<cfbreak />
			</cfif>
		</cfloop>

		<cfif hasLogger()><cfset getLogger().debug("Ending Workflow: #getWorkflowName()#") /></cfif>

		<cfreturn context />
    </cffunction>

	<cffunction name="setProcessContextClass" access="public" output="false" returntype="void">
    	<cfargument name="processContextClass" type="string" required="true" />
    	<cfset variables.instance.processContextClass = arguments.processContextClass />
    </cffunction>

	<cffunction name="setDefaultErrorHandler" access="public" output="false" returntype="void">
    	<cfargument name="defaultErrorHandler" type="any" required="true" />
    	<cfset variables.instance.defaultErrorHandler = arguments.defaultErrorHandler />
    </cffunction>

	<cffunction name="setLogger" access="public" output="false" returntype="void">
    	<cfargument name="logger" type="any" required="true" />
    	<cfset variables.instance.logger = arguments.logger />
    </cffunction>

<!------------------------------------------- PRIVATE ---------------------------------------------->

	<cffunction name="createContext" access="private" output="false" returntype="component">
		<cfargument name="params" type="struct" required="true" />

		<cfif hasProcessContextClass()>
			<cfreturn createObject("component",getProcessContextClass()).init(params) />
		<cfelse>
			<cfreturn createObject("component","Workflow.Framework.Context").init(params) />
		</cfif>
	</cffunction>

	<!--------------------------------------------------------------------------------------------->

	<cffunction name="getWorkflowName" access="private" output="false" returntype="string">
    	<cfreturn variables.instance.workflowName />
    </cffunction>

    <cffunction name="setWorkflowName" access="private" output="false" returntype="void">
    	<cfargument name="workflowName" type="string" required="true" />
    	<cfset variables.instance.workflowName = arguments.workflowName />
    </cffunction>

	<!--------------------------------------------------------------------------------------------->

	<cffunction name="getProcessContextClass" access="private" output="false" returntype="string">
    	<cfreturn variables.instance.processContextClass />
    </cffunction>

	<cffunction name="hasProcessContextClass" access="private" output="false" returntype="boolean">
    	<cfif len(variables.instance.processContextClass) NEQ 0>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
    </cffunction>

	<!--------------------------------------------------------------------------------------------->

	<cffunction name="getDefaultErrorHandler" access="private" output="false" returntype="component">
    	<cfreturn variables.instance.defaultErrorHandler />
    </cffunction>

	<cffunction name="hasDefaultErrorHandler" access="private" output="false" returntype="boolean">
    	<cfif isObject(variables.instance.defaultErrorHandler)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
    </cffunction>

	<!--------------------------------------------------------------------------------------------->

	<cffunction name="getLogger" access="private" output="false" returntype="component">
    	<cfreturn variables.instance.logger />
    </cffunction>

	<cffunction name="hasLogger" access="private" output="false" returntype="boolean">
    	<cfif isObject(variables.instance.logger)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
    </cffunction>

 	<!--------------------------------------------------------------------------------------------->
	<cffunction name="getActivities" access="private" output="false" returntype="array">
    	<cfreturn variables.instance.activities />
    </cffunction>

    <cffunction name="setActivities" access="private" output="false" returntype="void">
    	<cfargument name="activities" type="array" required="true" />
    	<cfset variables.instance.activities = arguments.activities />
    </cffunction>

</cfcomponent>