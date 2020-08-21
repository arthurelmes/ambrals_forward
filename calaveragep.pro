function calaveragep,field,id
jcount=n_elements(id)
;************read in parameter******************
dw=fltarr(1,jcount);downwelling
qcdw=fltarr(1,jcount)
uw=fltarr(1,jcount);upwelling
qcuw=fltarr(1,jcount)
dire=fltarr(1,jcount)
qcdire=fltarr(1,jcount)
diff=fltarr(1,jcount)
qcdiff=fltarr(1,jcount)
dir_r=fltarr(1,jcount)
zen=fltarr(1,jcount)
qcal=fltarr(1,jcount)
qcskyl=fltarr(1,jcount)
;**************output parameter*********************************
albedo=fltarr(1,jcount) ;use to calculate gnd_mean and gnd_sdev
skyl=fltarr(1,jcount)
dir_dif_ratio=fltarr(1,jcount)
;cfraction=
;******************get the data******************
  zen=field(7,id)
  dw=field(8,id)
  qcdw=field(9,id)
  uw=field(10,id)
  qcuw=field(11,id)
  dire=field(12,id)
  qcdire=field(13,id)
  diff=field(14,id)
  qcdiff=field(15,id)
  dir_r=dire*cos(zen/180*!pi)
  ;*******************do calculation for each time************************* 
for j = 0, jcount-1 do begin
 if qcdw(j) ne 1 and qcuw(j) ne 1 then begin ;make sure no missing value
    albedo(j)=uw(j)/dw(j)
  end
  qcal(j)=max([qcdw(j), qcuw(j)])
  ;************caculating the ratio of dire and diff **************************
  if qcdire(j) ne 1 and qcdiff(j) ne 1 then begin ;make sure no missing value
    if dir_r(j) lt 0 then dir_r(j)=0
    if diff(j) lt 0 then diff(j)=0
    skyl(j)=diff(j)/(diff(j)+dir_r(j))
    dir_dif_ratio(j)=dir_r(j)/diff(j)
  end
  qcskyl(j)=max([qcdire(j), qcdiff(j)])
endfor
gnd_mean=mean(albedo(where(qcal eq 0)))
gnd_sdev=stddev(albedo(where(qcal eq 0)))
skylq0=mean(skyl(where(qcskyl eq 0)))
dir_dif_ratio0=mean(dir_dif_ratio(where(qcskyl eq 0)))

outdata=[gnd_mean, gnd_sdev, skylq0, dir_dif_ratio0]
return, outdata
end