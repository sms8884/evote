/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

/**
 * <pre>
 * Class Name : SearchList.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 25.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 25.
 * @version 1.0
 */
public class SearchList<E> extends ArrayList<E> implements Serializable {

    private static final long serialVersionUID = -7784078594851735949L;

    private int totalCnt;

    public int getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

    public SearchList() {
        super();
    }

    public SearchList(Collection<E> c) {
        super(c);
    }

    public SearchList(Collection<E> c, int totalCnt) {
        super(c);
        setTotalCnt(totalCnt);
    }

}
