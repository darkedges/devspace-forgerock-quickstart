/*
 * Copyright 2020-2023 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */
import static java.util.Collections.singletonMap
import static org.forgerock.openam.amp.dsl.ConfigTransforms.*
import static org.forgerock.openam.amp.dsl.ServiceTransforms.*
import static org.forgerock.openam.amp.dsl.fbc.FileBasedConfigTransforms.*
import static org.forgerock.openam.amp.dsl.valueproviders.ValueProviders.objectProvider

/**
 * Placeholders to apply to AM 7.0.0 file config.
 *
 * <p>
 *     This is to be used in conjunction with the AM Docker image to placeholder the dev-ops static file deployment.
 *     This file therefore assumes values set by the AM Docker image deployment configuration based on the intended
 *     usage of the Docker image in a dev-ops deployment.
 * </p>
 */
def getRules() {
    return [
            forRealm("/",
                    replace("aliases")
                            .with(objectProvider(singletonMap("\$list", "&{am.server.hostnames|&{am.server.fqdn},am,am-config}")))),

            forGlobalService("amDataStoreService",
                    forDefaultInstanceSettings(
                            forNamedInstanceSettings("application-store",
                                    replace("dataStoreEnabled")
                                            .with(objectProvider(singletonMap("\$bool", "&{am.stores.application.enabled}"))),
                                    replace("bindDN")
                                            .with("&{am.stores.application.username}"),
                                    replace("bindPassword")
                                            .with("&{am.stores.application.password}"),
                                    replace("useSsl")
                                            .with(objectProvider(singletonMap("\$bool", "&{am.stores.application.ssl.enabled}"))),
                                    replace("serverUrls")
                                            .with(objectProvider(singletonMap("\$list", "&{am.stores.application.servers}")))),
                            forNamedInstanceSettings("policy-store",
                                    replace("dataStoreEnabled")
                                            .with(objectProvider(singletonMap("\$bool", "&{am.stores.policy.enabled}"))),
                                    replace("bindDN")
                                            .with("&{am.stores.policy.username}"),
                                    replace("bindPassword")
                                            .with("&{am.stores.policy.password}"),
                                    replace("useSsl")
                                            .with(objectProvider(singletonMap("\$bool", "&{am.stores.policy.ssl.enabled}"))),
                                    replace("serverUrls")
                                            .with(objectProvider(singletonMap("\$list", "&{am.stores.policy.servers}")))))),

            forRealmService("amRealmBaseURL",
                    forRealmDefaults(where(isAnything(),
                            replace("fixedValue")
                                    .with("&{am.server.protocol}://&{am.server.fqdn}")))),

            forRealmService("AuthenticatorOATH",
                    forRealmDefaults(where(isAnything(),
                            replace("authenticatorOATHDeviceSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("authenticatorOATHDeviceSettingsEncryptionKeystorePassword")
                                    .with("&{am.keystore.default.password}"),
                            replace("authenticatorOATHDeviceSettingsEncryptionKeystorePrivateKeyPassword") 
                                    .with("&{am.keystore.default.entry.password}")))),

            forRealmService("AuthenticatorPush",
                    forRealmDefaults(where(isAnything(),
                            replace("authenticatorPushDeviceSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("authenticatorPushDeviceSettingsEncryptionKeystorePassword")
                                    .with("&{am.keystore.default.password}"),
                            replace("authenticatorPushDeviceSettingsEncryptionKeystorePrivateKeyPassword") 
                                    .with("&{am.keystore.default.entry.password}")))),

            forRealmService("AuthenticatorWebAuthn",
                    forRealmDefaults(where(isAnything(),
                            replace("authenticatorWebAuthnDeviceSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("authenticatorWebAuthnDeviceSettingsEncryptionKeystorePassword")       
                                    .with("&{am.keystore.default.password}"),
                            replace("authenticatorWebAuthnDeviceSettingsEncryptionKeystorePrivateKeyPassword")
                                    .with("&{am.keystore.default.entry.password}")))),

            forRealmService("DeviceBinding",
                    forRealmDefaults(where(isAnything(),
                            replace("deviceBindingSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("deviceBindingSettingsEncryptionKeystorePassword")
                                    .with("&{am.keystore.default.password}"),
                            replace("deviceBindingSettingsEncryptionKeystorePrivateKeyPassword")
                                    .with("&{am.keystore.default.entry.password}")))),

            forRealmService("DeviceId",
                    forRealmDefaults(where(isAnything(),
                            replace("deviceIdSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("deviceIdSettingsEncryptionKeystorePassword")
                                    .with("&{am.keystore.default.password}"),
                            replace("deviceIdSettingsEncryptionKeystorePrivateKeyPassword")
                                    .with("&{am.keystore.default.entry.password}")))),

            forRealmService("DeviceProfiles",
                    forRealmDefaults(where(isAnything(),
                            replace("deviceProfilesSettingsEncryptionKeystore") 
                                    .with("&{secrets.path}/keystores/keystore.jks"),
                            replace("deviceProfilesSettingsEncryptionKeystoreType")
                                    .with("&{am.keystore.default.password}"),
                            replace("deviceProfilesSettingsEncryptionKeystorePrivateKeyPassword")
                                    .with("&{am.keystore.default.entry.password}")))),

            forGlobalService("KeyStoreSecretStore",
                    forDefaultInstanceSettings(forNamedInstanceSettings("default/default-keystore",
                            replace("file") 
                                    .with("&{secrets.path}/keystores/keystore.jceks")))),

            forGlobalService("FileSystemSecretStore",
                    forDefaultInstanceSettings(forNamedInstanceSettings("default/default-passwords-store",
                            replace("directory") 
                                    .with("&{secrets.path}/secrets/plain")))),

            forRealmService("iPlanetAMAuthAmsterService",
                    forRealmDefaults(replace("authorizedKeys")
                            .with("&{amster.secrets.keys.path|/home/forgerock/openam/security/keys/amster/authorized_keys}")),
                    forSettings(replace("authorizedKeys")
                            .with("&{amster.secrets.keys.path|/home/forgerock/openam/security/keys/amster/authorized_keys}"))),

            forRealmService("iPlanetAMAuthService",
                    forRealmDefaults(within("security",
                            where(isAnything(),
                                    replace("sharedSecret")
                                            .with("&{am.authentication.shared.secret}"))))),

            forRealmService("iPlanetAMAuthLDAPService",
                    forRealmDefaults(
                            replace("primaryLdapServer")
                                    .with(objectProvider(
                                            singletonMap("\$list", "&{am.authentication.modules.ldap.servers}"))),
                            replace("userBindDN")
                                    .with("&{am.authentication.modules.ldap.username}")),
                    forSettings(
                            replace("userBindPassword")
                                    .with("&{am.authentication.modules.ldap.password}")),
                    forSettings(
                            replace("openam-auth-ldap-connection-mode")
                                    .with("&{am.authentication.modules.ldap.connection.mode}"))),

            forGlobalService("iPlanetAMPlatformService",
                    forDefaultInstanceSettings(
                            forNamedInstanceSettings("http://am:80/am",
                                    withinSet("serverconfig")
                                            .replaceValueOfKey("am.encryption.pwd")
                                            .with("&{am.encryption.key}"),
                                    replace("serverconfigxml")
                                            .with(objectProvider(singletonMap("\$inline", "serverconfig.xml")))),
                            forNamedInstanceSettings("server-default",
                                    withinSet("serverconfig")
                                            .replaceValueOfKey("am.encryption.pwd")
                                            .with("&{am.encryption.key}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.password")
                                            .with("&{am.stores.cts.password}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.directory.name")
                                            .with("&{am.stores.cts.servers}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.loginid") 
                                            .with("&{am.stores.cts.username}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.ssl.enabled")
                                            .with("&{am.stores.cts.ssl.enabled}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.mtls.enabled")
                                            .with("&{am.stores.cts.mtls.enabled|false}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.root.suffix")
                                            .with("&{am.stores.cts.root.suffix}")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.affinity.enabled")
                                            .with("false")
                                            .replaceValueOfKey("org.forgerock.services.cts.store.starttls.enabled")
                                            .with("")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.location")
                                            .with("external")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.root.suffix")
                                            .with("&{am.stores.uma.root.suffix}")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.location")
                                            .with("external")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.root.suffix")
                                            .with("&{am.stores.uma.root.suffix}")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.location")
                                            .with("external")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.root.suffix")
                                            .with("&{am.stores.uma.root.suffix}")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.location")
                                            .with("external")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.root.suffix")
                                            .with("&{am.stores.uma.root.suffix}")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.password")
                                            .with("&{am.stores.uma.password}")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.directory.name")
                                            .with("&{am.stores.uma.servers}")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.loginid")
                                            .with("&{am.stores.uma.username}")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.ssl.enabled")
                                            .with("&{am.stores.uma.ssl.enabled}")
                                            .replaceValueOfKey("org.forgerock.services.resourcesets.store.mtls.enabled")
                                            .with("&{am.stores.uma.mtls.enabled|false}")

                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.password")
                                            .with("&{am.stores.uma.password}")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.directory.name")
                                            .with("&{am.stores.uma.servers}")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.loginid")
                                            .with("&{am.stores.uma.username}")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.ssl.enabled")
                                            .with("&{am.stores.uma.ssl.enabled}")
                                            .replaceValueOfKey("org.forgerock.services.umaaudit.store.mtls.enabled")
                                            .with("&{am.stores.uma.mtls.enabled|false}")

                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.password")
                                            .with("&{am.stores.uma.password}")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.directory.name")
                                            .with("&{am.stores.uma.servers}")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.loginid")
                                            .with("&{am.stores.uma.username}")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.ssl.enabled")
                                            .with("&{am.stores.uma.ssl.enabled}")
                                            .replaceValueOfKey("org.forgerock.services.uma.pendingrequests.store.mtls.enabled")
                                            .with("&{am.stores.uma.mtls.enabled|false}")

                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.password")
                                            .with("&{am.stores.uma.password}")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.directory.name")
                                            .with("&{am.stores.uma.servers}")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.loginid")
                                            .with("&{am.stores.uma.username}")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.ssl.enabled")
                                            .with("&{am.stores.uma.ssl.enabled}")
                                            .replaceValueOfKey("org.forgerock.services.uma.labels.store.mtls.enabled")
                                            .with("&{am.stores.uma.mtls.enabled|false}")
                            ),
                            forNamedInstanceSettings("accesspoint",
                                    replace("primary-url").with("&{am.server.protocol}://&{am.server.fqdn}")))),

            forRealmService("iPlanetAMPolicyConfigService",
                    forSettings(where(isAnything(),
                            replace("bindDn")
                                    .with("&{am.stores.policy.username}"),
                            replace("bindPassword")
                                    .with("&{am.stores.policy.password}"),
                            replace("sslEnabled")
                                    .with(objectProvider(singletonMap("\$bool", "&{am.stores.policy.ssl.enabled}"))))),
                    forRealmDefaults(where(isAnything(),
                            replace("bindDn")
                                    .with("&{am.stores.policy.username}"),
                            replace("bindPassword")
                                    .with("&{am.stores.policy.password}"),
                            replace("sslEnabled")
                                    .with(objectProvider(singletonMap("\$bool", "&{am.stores.policy.ssl.enabled}"))),
                            replace("ldapServer")
                                    .with(objectProvider(singletonMap("\$list", "&{am.stores.policy.servers}")))))),

            forGlobalService("iPlanetAMSessionService",
                    forSettings(within("stateless",
                            where(isDefault(),
                                    replace("statelessSigningHmacSecret")
                                            .with("&{am.session.stateless.signing.key}")))),
                    forSettings(within("stateless",
                            where(isDefault(),
                                    replace("statelessEncryptionAesKey")
                                            .with("&{am.session.stateless.encryption.key}"))))),

            forRealmService("OAuth2Provider",
                    forRealmDefaults(within("advancedOAuth2Config",
                            where(isAnything(),
                                    replace("hashSalt")
                                            .with("&{am.oidc.client.subject.identifier.hash.salt}"))))),   

            forRealmService("RestSecurity",
                    forRealmDefaults(
                            replace("confirmationIdHmacKey")
                                    .with("&{am.selfservice.legacy.confirmation.email.link.signing.key}"))),

            forRealmService("sunFAMSAML2Configuration",
                    forRealmDefaults(where(isAnything(),
                            replace("metadataSigningKeyPass")
                                    .with("&{am.keystore.default.password}")))),

            forGlobalService("sunIdentityRepositoryService",
                    forDefaultInstanceSettings(
                            forNamedInstanceSettings("amAdmin",
                                    replace("userPassword")
                                            .with("&{am.passwords.amadmin.hashed.encrypted}")),
                            forNamedInstanceSettings("anonymous",
                                    replace("userPassword")
                                            .with("&{am.passwords.anonymous.hashed.encrypted}")),
                            forNamedInstanceSettings("dsameuser",
                                    replace("userPassword")
                                            .with("&{am.passwords.dsameuser.hashed.encrypted}")))),        

            forRealmService("sunIdentityRepositoryService",
                    forDefaultInstanceSettings(
                            forNamedInstanceSettings("OpenDJ",
                                    within("ldapsettings",
                                            where(isAnything(),
                                                    replace("sun-idrepo-ldapv3-config-authpw")
                                                            .with("&{am.stores.user.password}"))),
                                    within("ldapsettings",
                                            where(isAnything(),
                                                    replace("sun-idrepo-ldapv3-config-authid")
                                                            .with("&{am.stores.user.username}"))),
                                    within("ldapsettings",
                                            where(isAnything(),
                                                    replace("sun-idrepo-ldapv3-config-connection-mode")    
                                                            .with("&{am.stores.user.connection.mode}"))),  
                                    within("ldapsettings",
                                            where(isAnything(),
                                                    replace("sun-idrepo-ldapv3-config-ldap-server")        
                                                            .with(objectProvider(singletonMap("\$list", "&{am.stores.user.servers}")))))))),
    ]
}