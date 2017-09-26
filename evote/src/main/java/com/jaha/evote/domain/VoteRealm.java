/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : VoteRealm.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 14.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 14.
 * @version 1.0
 */
public class VoteRealm extends RealmVO implements Serializable {

    private static final long serialVersionUID = -5874351716663541121L;

    private String voteSeq;
    private String useYn;

    public String getVoteSeq() {
        return voteSeq;
    }

    public void setVoteSeq(String voteSeq) {
        this.voteSeq = voteSeq;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

}
