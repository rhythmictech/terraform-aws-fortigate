config system admin
        edit admin
        set password "${password}"
end
config system interface
    edit "port1"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh fgfm
    next
    edit "port2"
        set vdom "root"
        set mode dhcp
        set allowaccess ping ssh https
    next
end
