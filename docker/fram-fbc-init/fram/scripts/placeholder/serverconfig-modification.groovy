/*
 * Copyright 2020 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */
import org.forgerock.openam.amp.dsl.conditions.ServiceInstanceCondition
import org.forgerock.openam.amp.framework.core.ServiceInstance
import org.forgerock.openam.amp.framework.servicetransform.ConfigProvider

import java.util.function.Function
import java.util.stream.Collectors

import static java.util.Arrays.asList
import static java.util.Collections.singletonList
import static java.util.Collections.singletonMap
import static org.forgerock.openam.amp.dsl.ConfigTransforms.*
import static org.forgerock.openam.amp.dsl.ServiceTransforms.*
import static org.forgerock.openam.amp.dsl.fbc.FileBasedConfigTransforms.*
import static org.forgerock.openam.amp.dsl.valueproviders.ValueProviders.objectProvider

/**
 * There is currently no way to make this change via REST in the base config so need to apply this
 * transformation over the file config post installation and setup.
 */
def getRules() {
    return [
            forGlobalService("iPlanetAMPlatformService",
                    forDefaultInstanceSettings(
                            forNamedInstanceSettings("http://am:80/am",
                                    withinSet("serverconfig")
                                            .removeEntryWithKey("org.forgerock.embedded.dsadminport")
                                            .removeEntryWithKey("com.sun.embedded.sync.servers")
                                            .removeEntryWithKey("com.sun.embedded.replicationport")
                                            .replaceValueOfKey("com.iplanet.am.server.port")
                                                    .with("80")
                                            .replaceValueOfKey("com.iplanet.am.server.host")
                                                    .with("am")
                                            .replaceValueOfKey("com.iplanet.am.server.protocol")
                                                    .with("http")
                                            .replaceValueOfKey("org.forgerock.donotupgrade")
                                                    .with("true")
                                            .replaceValueOfKey("com.iplanet.services.configpath")
                                                    .with("&{fram.home}")
                                            .replaceValueOfKey("com.iplanet.am.services.deploymentDescriptor")
                                                    .with("/am")
                            ),
                            forNamedInstanceSettings("server-default",
                                    addToSet("serverconfig")
                                            .with("com.sun.identity.server.fqdnMap[am]=am")))),
    ]
}
