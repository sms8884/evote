/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : BoardType.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 5.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 5.
 * @version 1.0
 */
public enum BoardType implements Serializable {

    /** 공지게시판 */
    NOTICE,

    /** 갤러리게시판 */
    GALLERY,

    /** 자료게시판 */
    DATA,

    /** QNA게시판 */
    QNA

}
