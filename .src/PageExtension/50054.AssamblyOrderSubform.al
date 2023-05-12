pageextension 50054 "Assembly Order Subform ex" extends "Assembly Order Subform"
{
    layout
    {
        modify("Variant Code") { Visible = false; }
        modify("Location Code") { Visible = true; }
        modify("Quantity to Consume") { Visible = false; }
        modify("Reserved Quantity") { Visible = false; }
        modify("Resource Usage Type") { Visible = false; }
        modify("Appl.-from Item Entry") { Visible = false; }
        modify("Appl.-to Item Entry") { Visible = false; }
    }
    actions
    {

    }
    var
        utility: Codeunit Utility;
}