echo off

SET command="%~dp0run_demand_allocation.rb"

if exist "C:\Program Files (x86)\Innovyze Workgroup Water Supply 4.5\iexchange.exe" (    
    "C:\Program Files (x86)\Innovyze Workgroup Water Supply 4.5\iexchange.exe" %command% /WS
) else if exist "C:\Program Files (x86)\Innovyze Workgroup Water Supply 4.0\iexchange.exe" (
    "C:\Program Files (x86)\Innovyze Workgroup Water Supply 4.0\iexchange.exe" %command% /WS
) else (
  echo Can not find InfoWorks Exchange
)

pause