tableextension 50024 "Production Forecasts Ex" extends "Production Forecast Entry"
{
    fields
    {
        modify("Item No.")
        {
            CaptionClass = 'Part No.';
            trigger OnAfterValidate()
            var
                ItemS: Record Item;
            begin
                if "Item No." <> '' then begin
                    ItemS.Get("Item No.");
                    if ItemS.Find('-') then begin
                        "Unit of Measure Code" := ItemS."Base Unit of Measure";
                        Description := ItemS.Description;
                        Model := ItemS."Description 2";
                    end;
                end;
            end;
        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
        field(50000; "Model"; Text[200])
        {

        }
    }
}