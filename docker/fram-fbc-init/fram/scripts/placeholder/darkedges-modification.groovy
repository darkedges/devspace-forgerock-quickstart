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
import java.util.regex.*

import static java.util.Arrays.asList
import static java.util.Collections.singletonList
import static java.util.Collections.singletonMap
import static org.forgerock.openam.amp.dsl.Conditions.key
import static org.forgerock.openam.amp.dsl.Conditions.entityIdIs
import static org.forgerock.openam.amp.dsl.ConfigTransforms.*
import static org.forgerock.openam.amp.dsl.ServiceTransforms.*
import static org.forgerock.openam.amp.dsl.fbc.FileBasedConfigTransforms.*
import static org.forgerock.openam.amp.dsl.valueproviders.ValueProviders.objectProvider
import static org.forgerock.openam.amp.dsl.valueproviders.ValueProviders.originalValueOfAttribute
import static org.forgerock.openam.amp.dsl.valueproviders.ValueProviders.valueOfAttribute
import static org.forgerock.openam.amp.dsl.Conditions.*

/**
 * There is currently no way to make this change via REST in the base config so need to apply this
 * transformation over the file config post installation and setup.
 */
def getRules() {
    return [
    ]
}

static String convertToPropertyValue(value) {
    value = replaceAll(value, "##(.*?)##")
    return replaceAll(value, "__(.*?)__")
}

static List convertToPropertyArray(values) {
        def a = new ArrayList()
        for (value in values)
                a.push(convertToPropertyValue(value))
        return a
}

static String convertURIToPropertyValue(value) {
    if ((value ==~ /.*##.*?##.*/) || (value ==~ /.*__.*?__.*/) | (value ==~ /.*64999.*/) )
        return convertToPropertyValue(value.replace('64999','&{fram.lb.port}').replace('https','&{fram.lb.scheme}'))
    else 
        return value
}

static List convertURIsToPropertyArray(values) {
        def a = new ArrayList()
        for (value in values)
                a.push(convertURIToPropertyValue(value))
        return a
}

static String replaceAll(String source, String regex) {
        if (source) {
                StringBuilder sb = new StringBuilder();
                Pattern pattern = Pattern.compile(regex);
                Matcher matcher = pattern.matcher(source);
                while (matcher.find()) {
                        matcher.appendReplacement(sb, ("&{"+matcher.group(1)+"}").toLowerCase().replaceAll("_","."));
                }
                matcher.appendTail(sb);
                return sb.toString();
        } else {
                return source
        }

}

static ArrayList replaceAll(ArrayList values, String regex) {
        def a = new ArrayList()
        for (value in values)
                a.push(replaceAll(value,regex))
        return a
}