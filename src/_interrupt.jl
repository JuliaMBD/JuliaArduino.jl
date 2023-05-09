export sei
export cli

"""
    sei()

Enable interuptions
"""
function sei()::Nothing
    Base.llvmcall(
        """
        call void asm sideeffect "sei", "" ()
        ret void
        """,
        Cvoid, Tuple{}
    )
    nothing
end

"""
    cli()

Disable any interuption globaly
"""
function cli()::Nothing
    Base.llvmcall(
        """
        call void asm sideeffect "cli", "" ()
        ret void
        """,
        Cvoid, Tuple{}
    )
    nothing
end

