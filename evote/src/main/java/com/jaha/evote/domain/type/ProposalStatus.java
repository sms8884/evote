/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : ProposalStatus.java
 * Description : 제안 > 제안처리상태
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 12.
 * @version 1.0
 */
public enum ProposalStatus implements Serializable {

    /** 검토대기 */
    PENDING,

    /** 검토중 */
    REVIEW,

    /** 검토완료 */
    COMPLETE;

}
