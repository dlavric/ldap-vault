# Repository that uses LDAP to authenticate to Vault


This repository is based on this [repo](https://github.com/hashicorp/vault-tools/tree/master/users/jodonnell/ldap-auth-example).


## Prerequisites
- [X] [Docker](https://docs.docker.com/get-docker/) 
- [X] [Vault](https://www.vaultproject.io/downloads) 


- Clone repo:
```shell
$ git clone git@github.com:dlavric/ldap-vault.git
```

- Access the directory where the repo is stored:
```shell
$ cd ldap-vault
```

- Execute the setup script:
```shell
$ chmod +x run.sh
$ ./run.sh
```

- Yu need to first login into vault with root:
```shell
$ vault login root
```

- Setup Vault to use the LDAP auth method:
```shell
$ vault auth enable ldap

$ vault write auth/ldap/config \
    url="ldap://ldap" \
    userdn="ou=users,dc=hashicorp,dc=com" \
    userattr="uid" \
    groupdn="ou=groups,dc=hashicorp,dc=com" \
    groupattr="cn" \
    groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
    binddn="cn=admin,dc=hashicorp,dc=com" \
    bindpass='admin'
```

- Create sample data to be accessed by distinct policies:
```shell
$ vault kv put secret/dev code=life
$ vault kv put secret/qa testing=rocks:
```

- Setup the policies which will be applied to our users using group mappings:
```shell
$ vault policy write dev - <<EOF
path "secret/data/dev" {
  capabilities = ["read"]
}
EOF

$ vault policy write qa - <<EOF
path "secret/data/qa" {
  capabilities = ["read"]
}
EOF
```

- Create the group policies to attach to users when they belong 
  to the appropriate LDAP groups:
```shell
$ vault write auth/ldap/groups/dev policies=dev
$ vault write auth/ldap/groups/qa policies=qa
```

## Testing

- Alice is in the dev group, so only access to secret/dev
```shell
$ vault login -method=ldap username=alice

$ vault kv get secret/dev
$ vault kv get secret/qa
```

- Bob is in the dev and qa groups, so can access both secrets
```shell
$ vault login -method=ldap username=bob

$ vault kv get secret/dev
$ vault kv get secret/qa
```

- Joe is in the qa groups, so only access to secret/qa
```shell
$ vault login -method=ldap username=joe

$ vault kv get secret/dev
$ vault kv get secret/qa
```

