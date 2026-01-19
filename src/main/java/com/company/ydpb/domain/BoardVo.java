package com.company.ydpb.domain;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.util.List;

@Data
@NoArgsConstructor
public class BoardVo {
    private Long bno;
    private String boTitle;
    private String boContent;
    private String deptName;
    private Long hit;
    private Timestamp regdate;
    private List<FileVo> files;

    public boolean getIsNew() {
        return Duration.between(this.regdate.toInstant(), Instant.now()).toHours() < 24;
    }
    public String getListFileType() {
        return this.files.isEmpty() ? "" : files.get(0).getFileType();
    }
}
