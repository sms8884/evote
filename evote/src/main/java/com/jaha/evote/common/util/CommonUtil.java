package com.jaha.evote.common.util;

import java.util.Map;

public class CommonUtil {

    public static void setPagingParams(Map<String, Object> params) {

        int pageNum = StringUtils.nvlInt(params.get("pageNum"), 1);
        int pageSize = StringUtils.nvlInt(params.get("pageSize"), 10);

        int startNum = (pageNum - 1) * pageSize;
        int endNum = pageSize;

        params.put("pageNum", pageNum);
        params.put("pageSize", pageSize);
        params.put("startNum", startNum);
        params.put("endNum", endNum);
    }

    public static void setSkipPagingParams(Map<String, Object> params) {

        int pageNum = StringUtils.nvlInt(params.get("pageNum"), 1);
        int pageSize = StringUtils.nvlInt(params.get("pageSize"), 5);
        int skipNum = StringUtils.nvlInt(params.get("skipNum"), 4);

        int startNum = ((pageNum - 1) * pageSize) + skipNum;
        int endNum = pageSize;

        params.put("startNum", startNum);
        params.put("endNum", endNum);
    }
}
