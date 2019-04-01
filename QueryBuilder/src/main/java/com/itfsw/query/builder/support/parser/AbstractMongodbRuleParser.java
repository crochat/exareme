/*
 * Copyright (c) 2017.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.itfsw.query.builder.support.parser;

import com.itfsw.query.builder.support.model.IRule;
import com.mongodb.DBObject;

/**
 * ---------------------------------------------------------------------------
 *
 * ---------------------------------------------------------------------------
 * @author: hewei
 * @time:2017/11/1 18:35
 * ---------------------------------------------------------------------------
 */
public abstract class AbstractMongodbRuleParser implements IRuleParser {
    /**
     * 是否可以解析
     * @param rule
     * @return
     */
    public abstract boolean canParse(IRule rule);

    /**
     * 解析
     * @param rule
     * @param parser
     * @return
     */
    public abstract DBObject parse(IRule rule, JsonRuleParser parser);
}
