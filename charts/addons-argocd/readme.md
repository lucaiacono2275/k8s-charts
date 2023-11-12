# Integrating Keycloak and ArgoCD
These instructions will take you through the entire process of getting your ArgoCD application authenticating with Keycloak. You will create a client within Keycloak and configure ArgoCD to use Keycloak for authentication, using groups set in Keycloak to determine privileges in Argo.

## Creating a new client in Keycloak
First we need to setup a new client. Start by logging into your keycloak server, select the realm you want to use (master by default) and then go to Clients and click the Create client button at the top.

* Keycloak add client

* Enable the Client authentication.

* Keycloak add client Step 2

* Configure the client by setting the Root URL, Web origins, Admin URL to the hostname (https://{hostname}).

* Also you can set Home URL to your `/applications` path and Valid Post logout redirect URIs to "+".

The Valid Redirect URIs should be set to https://{hostname}/auth/callback (you can also set the less secure https://{hostname}/* for testing/development purposes, but it's not recommended in production).

Make sure to click Save. There should be a tab called Credentials. You can copy the Secret that we'll use in our ArgoCD configuration.


## Configuring the groups claim
In order for ArgoCD to provide the groups the user is in we need to configure a groups claim that can be included in the authentication token. To do this we'll start by creating a new Client Scope called groups.

Once you've created the client scope you can now add a Token Mapper which will add the groups claim to the token when the client requests the groups scope. In the Tab "Mappers", click on "Configure a new mapper" and choose Group Membership. Make sure to set the Name as well as the Token Claim Name to groups. Also disable the "Full group path".

We can now configure the client to provide the groups scope. Go back to the client we've created earlier and go to the Tab "Client Scopes". Click on "Add client scope", choose the groups scope and add it either to the Default or to the Optional Client Scope. If you put it in the Optional category you will need to make sure that ArgoCD requests the scope in its OIDC configuration. Since we will always want group information, I recommend using the Default category.

Create a group called ArgoCDAdmins and have your current user join the group.
