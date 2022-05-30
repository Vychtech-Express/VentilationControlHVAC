# Серверная компонента

# ��������� ���������� �������
package require Thread
# ��������� ��������� �� 7000 tcp �����
# ��� ��������� ������� �� �������, ����� ����������� ��������� _Accept
socket -server _Accept 7000
# ������ � ���������� tcl �������
# ��� ������ ������, ��� �� tcl-���������� ����������. 
# ��� Tk-���������� ������ ������ �� �����.
vwait forever

# ���������� ���������� �����
# � ���� 5 ����� ������� ������������ ������� �� 400-�� ��������
set Main(TcpPool,maxjobs) 5
# ������� ��� ������� �� ���� �����
set Main(tcptpid) [tpool::create -minworkers $Main(TcpPool,maxjobs) -maxworkers $Main(TcpPool,maxjobs)) -initcmd {
  # �������������� ����������, �������� ���������� �������� �����
  tsv::set TcpTpool CountJobs 0
  
  # ��������� ��������� ������� ����������
  foreach { p } { Pgtcl tls md5 crc32 } {
    package require $p
  }

  # ��������� �������� ��� ���������� � ������ ������
  foreach { s } { lib mainthreadtcp protocol protocolt } {
    uplevel #0 source $s.tcl
  }
}]

# ���������������� � �������� ��������� ������ � �������� �������������� � ��������� (�� �������) ���
proc _Accept {idsocket ipaddr port} {
  # ��������� ������� ������ � ��������� ����� ������ ��������������
  after idle [list Accept $idsocket $ipaddr $port]
}

# ����������, �������� ����� � ��������� ���
proc Accept { idsocket addr port } {
  global Main
  
  # ���������, ���� �� ��������� ����
  if { [tsv::get TcpTpool CountJobs] > $Main(TcpPool,maxjobs) } {
    # ��������� ����� ���. ��������� �����. ���������� � ��������� ������� �� �������
    close $idsocket
    return
  }
  
  # �������� ����� � �������� �������������� � ������������� ����������� ������
  tsv::incr TcpTpool CountJobs
  thread::detach $idsocket
  tpool::post -detached -nowait $Main(tcptpid) [list Accept:Thread $addr $idsocket]
}

# ��������� �������� ����������� ������ ������ �� ������
proc Accept:Thread { addr idsocket } {
  global ProcedureExec

  # ��� ��� ������ �������������� ���������� ���, ����������� �� �������, ���������� ����
  set handler [clock click -microseconds]
  set ProcedureExec($handler) -2
  # ���������, ����� �� ������� ����� � ���������� ���, ������ 60 ������ �� ������� �������
  after 60000 Timer:CheckConnectedSocket $handler $idsocket $addr

  # ������������, ����� ������������ �� �������� ��������������, ����� � ������� ���
  thread::attach $idsocket
  # ������������� �����
  # �����, ��� ���������� ��������� ������ ������ � ������, ����� ������ ���� � ������������� ������
  chan configure $idsocket -blocking 0 -buffering line -encoding binary -translation binary
  # ������ ���������� ���������� ������ ������ � ������
  # ��� ������������� ������ �� ������, ����������� ��������� SocketEventHandler:Thread
  chan event $idsocket readable [list SocketEventHandler:Thread $handler $idsocket $addr]

  # ��������� ��� ������ �� ������� ��������� ����������
  vwait Main($idsocket,IsRun)
}

# ���������, ����� �� ������� ����� � ���������� ���
proc Timer:CheckConnectedSocket { handler idsocket addr } {
  global ProcedureExec

  if { $ProcedureExec($handler) == -1 } return
  if { $ProcedureExec($handler) in "-2 1" } {
    # ���������, �� ����������� �� � ������� ������ �������� ������ �� ������� �������
    set p [chan pending output $idsocket]
    if { $p == 0 } {
      # �������� ������ ������� ���������. ����������� ���
      Exit:Thread $handler $idsocket
      return
    }
  }
  
  # �������� ������ ������� ������������. ��������� ���������� �������� ����� ���� �������
  after 1000 Timer:CheckConnectedSocket $handler $idsocket $addr
}


proc Exit:Thread { handler idsocket } {
  global ProcedureExec

  set ProcedureExec($handler) -1
  # �������������� ���������� ������� �����
  tsv::incr TcpTpool CountJobs -1

  # ������������� ���������� ���������� ������ ������ � ������
  catch { chan event $idsocket readable {} }
  # ��������� �����
  catch { chan close $idsocket }
  # �������� �������� ���������� ��� ��������� ����
  set Main($idsocket,IsRun) 0
}

# ������ ������ � ������
proc SocketEventHandler:Thread { handler idsocket addr } {
  global ProcedureExec

  if { [chan eof $idsocket] || [catch {chan gets $idsocket pkt} err] != 0 } {
    Exit:Thread $handler $idsocket
    return
  } else {
    # ����� �������� ��� �� ��������� ����������� ������
    # ���������� pkt �������� ���������� ������ �� �������
    
    set ProcedureExec($handler) 1
  }
}

