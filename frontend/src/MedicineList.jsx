import React, { useEffect, useState } from "react";
import web3 from "../web3";
import Medicine from "../../build/contracts/Medicine.json";

function MedicineList() {
    const [medicines, setMedicines] = useState([]);

    useEffect(() => {
        const fetchMedicines = async () => {
            const deployedNetwork = Medicine.networks["5777"];
            const contract = new web3.eth.Contract(Medicine.abi, deployedNetwork.address);
            const result = await contract.methods.getAllMedicines().call();
            setMedicines(result);
        };
        fetchMedicines();
    }, []);

    return (
        <div>
            <h2>Medicines</h2>
            <ul>
                {medicines.map((med, idx) => (
                    <li key={idx}>{med}</li>
                ))}
            </ul>
        </div>
    );
}