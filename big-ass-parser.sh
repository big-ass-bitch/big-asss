#!/bin/bash

# Check if the user provided an input file
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file.txt"
    exit 1
fi

input_file="$1"
output_file="output.csv"

# Create or clear the output file and write the header
echo "Date and Time,Time (s),Temperature (°C),Relative Humidity (%),Absolute Humidity (g/m³),Barometric Pressure (mmHg),Wind Speed, 271-304 (mph),Dew Point (°C),Wind Chill (°C),Humidex (°C),Satellite Count,Latitude, 271-304 (°),Longitude, 271-304 (°),Altitude, 271-304 (m),Speed, 271-304 (m/s),UV Index,Illuminance, 271-304 (lx),Solar Irradiance, 271-304 (W/m²),Solar PAR (μmol/m²/s),Wind Direction (°),Magnetic Heading (°),True Heading (°)" > "$output_file"

# Read the entire input file as a single line
line=$(<"$input_file")

# Split the line into individual points using a regex to match "Point #"
IFS=' ' read -ra points <<< "$line"

# Initialize a temporary variable to hold point data
current_point=""

# Loop through each word and collect the necessary data
for word in "${points[@]}"; do
    if [[ "$word" == Point* ]]; then
        if [[ -n "$current_point" ]]; then
            # Process the current point before moving to the next
            date_time=$(echo "$current_point" | grep -o 'Date and Time = [^ ]* [^ ]* [^ ]*' | cut -d'=' -f2 | xargs)
            time_s=$(echo "$current_point" | grep -o 'Time (s) = [0-9.]*' | cut -d'=' -f2 | xargs)
            temp=$(echo "$current_point" | grep -o 'Temperature (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            rh=$(echo "$current_point" | grep -o 'Relative Humidity (%) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            ah=$(echo "$current_point" | grep -o 'Absolute Humidity (g/m³) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            bp=$(echo "$current_point" | grep -o 'Barometric Pressure (mmHg) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            ws=$(echo "$current_point" | grep -o 'Wind Speed, 271-304 (mph) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            dp=$(echo "$current_point" | grep -o 'Dew Point (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            wc=$(echo "$current_point" | grep -o 'Wind Chill (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            hum=$(echo "$current_point" | grep -o 'Humidex (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            sat_count=$(echo "$current_point" | grep -o 'Satellite Count = [0-9]*' | cut -d'=' -f2 | xargs)
            lat=$(echo "$current_point" | grep -o 'Latitude, 271-304 (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            long=$(echo "$current_point" | grep -o 'Longitude, 271-304 (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            alt=$(echo "$current_point" | grep -o 'Altitude, 271-304 (m) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            speed=$(echo "$current_point" | grep -o 'Speed, 271-304 (m/s) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            uv_index=$(echo "$current_point" | grep -o 'UV Index = [0-9.-]*' | cut -d'=' -f2 | xargs)
            illuminance=$(echo "$current_point" | grep -o 'Illuminance, 271-304 (lx) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            solar_ir=$(echo "$current_point" | grep -o 'Solar Irradiance, 271-304 (W/m²) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            solar_par=$(echo "$current_point" | grep -o 'Solar PAR (μmol/m²/s) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            wind_direction=$(echo "$current_point" | grep -o 'Wind Direction (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            magnetic_heading=$(echo "$current_point" | grep -o 'Magnetic Heading (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
            true_heading=$(echo "$current_point" | grep -o 'True Heading (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)

            # Combine the extracted fields into a CSV line
            csv_line="$date_time,$time_s,$temp,$rh,$ah,$bp,$ws,$dp,$wc,$hum,$sat_count,$lat,$long,$alt,$speed,$uv_index,$illuminance,$solar_ir,$solar_par,$wind_direction,$magnetic_heading,$true_heading"

            # Append the CSV line to the output file, only if the line is valid
            if [[ -n "$csv_line" ]]; then
                echo "$csv_line" >> "$output_file"
            fi
        fi
        # Start a new point
        current_point="$word"
    else
        current_point+=" $word"
    fi
done

# Process the last point if it exists
if [[ -n "$current_point" ]]; then
    date_time=$(echo "$current_point" | grep -o 'Date and Time = [^ ]* [^ ]* [^ ]*' | cut -d'=' -f2 | xargs)
    time_s=$(echo "$current_point" | grep -o 'Time (s) = [0-9.]*' | cut -d'=' -f2 | xargs)
    temp=$(echo "$current_point" | grep -o 'Temperature (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    rh=$(echo "$current_point" | grep -o 'Relative Humidity (%) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    ah=$(echo "$current_point" | grep -o 'Absolute Humidity (g/m³) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    bp=$(echo "$current_point" | grep -o 'Barometric Pressure (mmHg) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    ws=$(echo "$current_point" | grep -o 'Wind Speed, 271-304 (mph) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    dp=$(echo "$current_point" | grep -o 'Dew Point (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    wc=$(echo "$current_point" | grep -o 'Wind Chill (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    hum=$(echo "$current_point" | grep -o 'Humidex (°C) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    sat_count=$(echo "$current_point" | grep -o 'Satellite Count = [0-9]*' | cut -d'=' -f2 | xargs)
    lat=$(echo "$current_point" | grep -o 'Latitude, 271-304 (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    long=$(echo "$current_point" | grep -o 'Longitude, 271-304 (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    alt=$(echo "$current_point" | grep -o 'Altitude, 271-304 (m) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    speed=$(echo "$current_point" | grep -o 'Speed, 271-304 (m/s) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    uv_index=$(echo "$current_point" | grep -o 'UV Index = [0-9.-]*' | cut -d'=' -f2 | xargs)
    illuminance=$(echo "$current_point" | grep -o 'Illuminance, 271-304 (lx) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    solar_ir=$(echo "$current_point" | grep -o 'Solar Irradiance, 271-304 (W/m²) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    solar_par=$(echo "$current_point" | grep -o 'Solar PAR (μmol/m²/s) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    wind_direction=$(echo "$current_point" | grep -o 'Wind Direction (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    magnetic_heading=$(echo "$current_point" | grep -o 'Magnetic Heading (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)
    true_heading=$(echo "$current_point" | grep -o 'True Heading (°) = [0-9.-]*' | cut -d'=' -f2 | xargs)

    # Combine the extracted fields into a CSV line
    csv_line="$date_time,$time_s,$temp,$rh,$ah,$bp,$ws,$dp,$wc,$hum,$sat_count,$lat,$long,$alt,$speed,$uv_index,$illuminance,$solar_ir,$solar_par,$wind_direction,$magnetic_heading,$true_heading"

    # Append the CSV line to the output file, only if the line is valid
    if [[ -n "$csv_line" ]]; then
        echo "$csv_line" >> "$output_file"
    fi
fi

echo "Conversion complete. Output saved to $output_file."
