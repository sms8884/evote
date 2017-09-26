/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;

import org.springframework.stereotype.Service;

/**
 * <pre>
 * Class Name : ExcelService.java
 * Description : 엑셀 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 28.
 * @version 1.0
 */
@Service
public class ExcelService extends BaseService {

    public void insertExcelData(List<String[]> excelData) {

        if (excelData != null) {

            for (String[] values : excelData) {
                for (String value : values) {
                    logger.debug("### value : [{}]", value);
                }
            }

        }

    }



}
