package com.company.ydpb.domain;

import lombok.Data;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Data
public class GuNewsVo {
    private long gsNo;
    private String gsTitle;
    private String gsContent;
    private String gsDepart;
    private String gsTel;
    private String gsHit;
    private String gsFiles;
    private String gsNuri;
    private Timestamp gsRegdate;

    public List<FileDto> getFiles() {
        List<FileDto> list = new ArrayList<>();
        if(this.gsFiles != null && !this.gsFiles.isEmpty()) {
            for(int i = 0; i < this.gsFiles.split(",").length; i++) {
                String fileName = this.gsFiles.split(",")[i];
                String[] fileNameArr = fileName.split("\\.");
                FileDto file = new FileDto();
                file.setName(fileName);
                file.setType(fileNameArr[fileNameArr.length - 1]);
                list.add(file);
            }
        }
        return list;
    }
    public String getFileType() {
        String result = null;
        if(this.gsFiles != null && !this.gsFiles.isEmpty()) {
            result = getFiles().get(0).getType();
        }
        return result;
    }
    public boolean getIsNew() {
        return Duration.between(this.gsRegdate.toInstant(), Instant.now()).toHours() < 24;
    }
}
