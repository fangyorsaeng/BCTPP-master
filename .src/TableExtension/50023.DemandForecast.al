tableextension 50023 "Demand Forecasts Ex" extends "Production Forecast Name"
{
    fields
    {
        field(50000; "Customer"; Code[20])
        {
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                Cust.Reset();
                Cust.SetRange("No.", Customer);
                if Cust.Find('-') then begin
                    "Customer Name" := Cust.Name;
                end;
            end;
        }
        field(50001; "Customer Name"; Text[250])
        {
            Editable = false;
        }
        field(50002; "Search Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Search Name" where("No." = field(Customer)));
        }

    }
}